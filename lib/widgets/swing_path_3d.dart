import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
import '../models/swing_event.dart';
import '../theme/augusta_theme.dart';

/// Renders a reconstructed 3D club head trajectory from downswing gyro samples.
///
/// The path is computed by integrating angular velocity to build successive
/// orientations, then projecting the club head tip at each step. The result
/// is displayed with perspective projection and can be rotated via pan gesture.
class SwingPath3D extends StatefulWidget {
  final List<GyroSample> samples;
  final double clubLengthM;
  final double? peakSpeedMph;

  const SwingPath3D({
    super.key,
    required this.samples,
    required this.clubLengthM,
    this.peakSpeedMph,
  });

  @override
  State<SwingPath3D> createState() => _SwingPath3DState();
}

class _SwingPath3DState extends State<SwingPath3D> {
  double _rotationX = 0.3; // initial tilt for a good default view
  double _rotationY = -0.4;

  /// Precomputed 3D path positions and their associated omega values.
  late List<vm.Vector3> _pathPoints;
  late List<double> _pathOmegas;
  late int _impactIndex;
  late double _maxOmega;
  late double _minOmega;

  @override
  void initState() {
    super.initState();
    _computePath();
  }

  @override
  void didUpdateWidget(SwingPath3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.samples, widget.samples) ||
        oldWidget.clubLengthM != widget.clubLengthM) {
      _computePath();
    }
  }

  void _computePath() {
    final samples = widget.samples;
    if (samples.isEmpty) {
      _pathPoints = [];
      _pathOmegas = [];
      _impactIndex = 0;
      _maxOmega = 1.0;
      _minOmega = 0.0;
      return;
    }

    const double dt = 0.01; // 100 Hz assumed
    final clubVec = vm.Vector3(0, -widget.clubLengthM, 0);

    var orientation = vm.Quaternion.identity();
    final points = <vm.Vector3>[];
    final omegas = <double>[];
    double peak = 0.0;
    double lowestY = double.infinity;
    int impactIdx = 0;

    for (var i = 0; i < samples.length; i++) {
      final s = samples[i];
      omegas.add(s.omega);

      if (s.omega > peak) {
        peak = s.omega;
      }

      // Compute club head position at current orientation
      final rotated = orientation.rotated(clubVec);
      points.add(rotated);

      // Impact = lowest point in the arc (minimum Y coordinate)
      if (rotated.y < lowestY) {
        lowestY = rotated.y;
        impactIdx = i;
      }

      // Integrate angular velocity to update orientation
      if (s.omega > 1e-6) {
        final angle = s.omega * dt;
        final axis = vm.Vector3(s.x, s.y, s.z).normalized();
        final delta = vm.Quaternion.axisAngle(axis, angle);
        orientation = delta * orientation;
        orientation.normalize();
      }
    }

    _pathPoints = points;
    _pathOmegas = omegas;
    _impactIndex = impactIdx;
    _maxOmega = peak > 0 ? peak : 1.0;
    _minOmega = omegas.isEmpty ? 0.0 : omegas.reduce(math.min);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.samples.isEmpty) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          return GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _rotationY += details.delta.dx * 0.01;
                _rotationX += details.delta.dy * 0.01;
                _rotationX = _rotationX.clamp(-math.pi / 2, math.pi / 2);
              });
            },
            child: CustomPaint(
              size: size,
              painter: _SwingPath3DPainter(
                pathPoints: _pathPoints,
                pathOmegas: _pathOmegas,
                impactIndex: _impactIndex,
                maxOmega: _maxOmega,
                minOmega: _minOmega,
                rotationX: _rotationX,
                rotationY: _rotationY,
                peakSpeedMph: widget.peakSpeedMph,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SwingPath3DPainter extends CustomPainter {
  final List<vm.Vector3> pathPoints;
  final List<double> pathOmegas;
  final int impactIndex;
  final double maxOmega;
  final double minOmega;
  final double rotationX;
  final double rotationY;
  final double? peakSpeedMph;

  // Speed gradient: yellow (slow) → orange (medium) → red (fastest)
  static const _slowColor = Color(0xFFFFD54F);   // yellow
  static const _midColor = Color(0xFFFF8C00);     // orange
  static const _fastColor = Color(0xFFE53935);    // red

  _SwingPath3DPainter({
    required this.pathPoints,
    required this.pathOmegas,
    required this.impactIndex,
    required this.maxOmega,
    required this.minOmega,
    required this.rotationX,
    required this.rotationY,
    this.peakSpeedMph,
  });

  /// Build a view rotation matrix from the current pan angles.
  vm.Matrix4 _viewMatrix() {
    final mat = vm.Matrix4.identity();
    mat.rotateX(rotationX);
    mat.rotateY(rotationY);
    return mat;
  }

  /// Project a 3D point to 2D screen coordinates with perspective.
  Offset _project(vm.Vector3 p, vm.Matrix4 view, double cx, double cy, double focalLength) {
    final transformed = view.transformed3(p);
    final z = transformed.z + focalLength * 2; // push scene in front of camera
    if (z < 0.1) return Offset(cx, cy); // behind camera
    final sx = focalLength * transformed.x / z + cx;
    final sy = focalLength * transformed.y / z + cy;
    return Offset(sx, sy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final focalLength = size.width * 0.8;
    final view = _viewMatrix();

    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = AugustaTheme.background,
    );

    // Draw ground grid
    _drawGrid(canvas, size, view, cx, cy, focalLength);

    // Draw axis indicators
    _drawAxes(canvas, view, cx, cy, focalLength);

    if (pathPoints.length < 2) return;

    // Draw the swing path
    final omegaRange = maxOmega - minOmega;

    for (var i = 0; i < pathPoints.length - 1; i++) {
      final p0 = _project(pathPoints[i], view, cx, cy, focalLength);
      final p1 = _project(pathPoints[i + 1], view, cx, cy, focalLength);

      final t = omegaRange > 0 ? (pathOmegas[i] - minOmega) / omegaRange : 0.0;
      // Two-stop gradient: yellow (0.0) → orange (0.5) → red (1.0)
      final color = t < 0.5
          ? Color.lerp(_slowColor, _midColor, t * 2)!
          : Color.lerp(_midColor, _fastColor, (t - 0.5) * 2)!;
      final strokeWidth = 1.5 + t * 3.5; // thicker = faster

      canvas.drawLine(
        p0,
        p1,
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    // Draw impact point (peak omega)
    if (impactIndex < pathPoints.length) {
      final impactScreen = _project(pathPoints[impactIndex], view, cx, cy, focalLength);

      // Outer glow
      canvas.drawCircle(
        impactScreen,
        10,
        Paint()
          ..color = _fastColor.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      // Inner dot
      canvas.drawCircle(
        impactScreen,
        5,
        Paint()..color = _fastColor,
      );

      // Label with peak speed
      if (peakSpeedMph != null) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${peakSpeedMph!.toStringAsFixed(1)} mph',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFFF5F0E8),
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(
          canvas,
          Offset(impactScreen.dx + 8, impactScreen.dy - textPainter.height / 2),
        );
      }
    }

    // Touch hint text
    final hintPainter = TextPainter(
      text: TextSpan(
        text: 'drag to rotate',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 9,
          color: AugustaTheme.textSecondary.withValues(alpha: 0.5),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    hintPainter.paint(
      canvas,
      Offset(size.width - hintPainter.width - 8, size.height - hintPainter.height - 8),
    );
  }

  void _drawGrid(Canvas canvas, Size size, vm.Matrix4 view, double cx, double cy, double focalLength) {
    final gridPaint = Paint()
      ..color = AugustaTheme.textSecondary.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;

    const gridSize = 0.5; // meters
    const gridCount = 4;
    const y = 0.0; // ground plane at y=0 (shaft hangs below)

    for (var i = -gridCount; i <= gridCount; i++) {
      final t = i * gridSize;
      final a = _project(vm.Vector3(t, y, -gridCount * gridSize), view, cx, cy, focalLength);
      final b = _project(vm.Vector3(t, y, gridCount * gridSize), view, cx, cy, focalLength);
      canvas.drawLine(a, b, gridPaint);

      final c = _project(vm.Vector3(-gridCount * gridSize, y, t), view, cx, cy, focalLength);
      final d = _project(vm.Vector3(gridCount * gridSize, y, t), view, cx, cy, focalLength);
      canvas.drawLine(c, d, gridPaint);
    }
  }

  void _drawAxes(Canvas canvas, vm.Matrix4 view, double cx, double cy, double focalLength) {
    final origin = _project(vm.Vector3.zero(), view, cx, cy, focalLength);
    const axisLen = 0.3;

    // X = red
    final xEnd = _project(vm.Vector3(axisLen, 0, 0), view, cx, cy, focalLength);
    canvas.drawLine(origin, xEnd, Paint()..color = Colors.red.withValues(alpha: 0.6)..strokeWidth = 1.5);

    // Y = green
    final yEnd = _project(vm.Vector3(0, axisLen, 0), view, cx, cy, focalLength);
    canvas.drawLine(origin, yEnd, Paint()..color = Colors.green.withValues(alpha: 0.6)..strokeWidth = 1.5);

    // Z = blue
    final zEnd = _project(vm.Vector3(0, 0, axisLen), view, cx, cy, focalLength);
    canvas.drawLine(origin, zEnd, Paint()..color = Colors.blue.withValues(alpha: 0.6)..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(_SwingPath3DPainter oldDelegate) {
    return rotationX != oldDelegate.rotationX ||
        rotationY != oldDelegate.rotationY ||
        !identical(pathPoints, oldDelegate.pathPoints);
  }
}
