import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/history_provider.dart';
import '../providers/session_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/augusta_theme.dart';
import '../widgets/speed_distribution_chart.dart';

// NOTE: 3D swing path visualization is only available during the active
// session (in-memory data). Persisting downswing gyro samples would require
// a separate database table or a JSON blob column on the swings table.
// Until then, the SwingPath3D widget is shown only on ActiveSessionScreen.
class SessionSummaryScreen extends ConsumerStatefulWidget {
  final int sessionId;
  final bool isReadOnly;
  final bool isRecovery;

  const SessionSummaryScreen({
    super.key,
    required this.sessionId,
    this.isReadOnly = false,
    this.isRecovery = false,
  });

  @override
  ConsumerState<SessionSummaryScreen> createState() =>
      _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends ConsumerState<SessionSummaryScreen> {
  List<Swing>? _swings;
  bool _isCommitting = false;
  String? _commitError;

  @override
  void initState() {
    super.initState();
    _loadSwings();
  }

  Future<void> _loadSwings() async {
    final swings = await ref
        .read(swingDaoProvider)
        .getSwingsForSession(widget.sessionId);
    if (mounted) setState(() => _swings = swings);
  }

  // Compute stats from swings directly (not from session row)
  Map<String, dynamic> _computeStats(List<Swing> swings) {
    if (swings.isEmpty) {
      return {
        'count': 0, 'peak': 0.0, 'avg': 0.0, 'consistency': null,
        'speeds': <double>[],
      };
    }
    final speeds = swings.map((s) => s.peakSpeedMph).toList();
    final peak = speeds.reduce(math.max);
    final avg = speeds.reduce((a, b) => a + b) / speeds.length;
    double? consistency;
    if (speeds.length >= 2) {
      final variance = speeds
              .map((s) => (s - avg) * (s - avg))
              .reduce((a, b) => a + b) /
          speeds.length;
      final sigma = math.sqrt(variance);
      consistency = math.max(0.0, 100.0 - sigma * 5.0);
    }
    return {
      'count': speeds.length,
      'peak': peak,
      'avg': avg,
      'consistency': consistency,
      'speeds': speeds,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_swings == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    final stats = _computeStats(_swings!);
    final settingsAsync = ref.watch(settingsProvider);
    final isNewPB = settingsAsync.whenOrNull(
          data: (s) => (stats['peak'] as double) > s.allTimePeakMph,
        ) ??
        false;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('SESSION SUMMARY',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AugustaTheme.gold,
                    letterSpacing: 3,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),

              // Personal best badge
              if (isNewPB && !widget.isReadOnly)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AugustaTheme.gold),
                  ),
                  child: Text('NEW PERSONAL BEST!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AugustaTheme.gold,
                      )),
                ),

              // Stat row
              _StatRow(stats: stats),
              const SizedBox(height: 32),

              // Distribution chart
              Text('SPEED DISTRIBUTION',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AugustaTheme.gold,
                    letterSpacing: 3,
                  )),
              const SizedBox(height: 12),
              SpeedDistributionChart(speeds: List<double>.from(stats['speeds'])),
              const SizedBox(height: 32),

              // Swing timeline
              Text('SWING TIMELINE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AugustaTheme.gold,
                    letterSpacing: 3,
                  )),
              const SizedBox(height: 12),
              ..._swings!.asMap().entries.map((e) {
                final i = e.key;
                final swing = e.value;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: AugustaTheme.surface,
                    border: Border(
                        left: BorderSide(
                            color: AugustaTheme.gold.withValues(alpha: 0.3),
                            width: 2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('#${i + 1}',
                              style: TextStyle(
                                  color: AugustaTheme.textSecondary,
                                  fontFamily: 'Inter')),
                          Text(
                              '${swing.peakSpeedMph.toStringAsFixed(1)} mph',
                              style: TextStyle(
                                  color: AugustaTheme.textPrimary,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold)),
                          Text('${(swing.durationMs / 1000).toStringAsFixed(2)}s',
                              style: TextStyle(
                                  color: AugustaTheme.textSecondary,
                                  fontFamily: 'Inter')),
                        ],
                      ),
                      if (swing.attackAngleDeg != null || swing.swingPathDeg != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (swing.attackAngleDeg != null)
                                Text(
                                  'ATK: ${swing.attackAngleDeg! >= 0 ? '+' : ''}${swing.attackAngleDeg!.toStringAsFixed(1)}\u00B0',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: swing.attackAngleDeg! >= 0
                                        ? Colors.orange.shade300
                                        : Colors.blue.shade300,
                                  ),
                                ),
                              if (swing.attackAngleDeg != null && swing.swingPathDeg != null)
                                const SizedBox(width: 12),
                              if (swing.swingPathDeg != null)
                                Text(
                                  'PATH: ${swing.swingPathDeg! >= 0 ? '+' : ''}${swing.swingPathDeg!.toStringAsFixed(1)}\u00B0',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: AugustaTheme.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 32),

              // Action buttons
              if (!widget.isReadOnly) ...[
                if (_commitError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_commitError!,
                        style: TextStyle(color: Colors.red.shade300),
                        textAlign: TextAlign.center),
                  ),
                ElevatedButton(
                  onPressed: _isCommitting
                      ? null
                      : () async {
                          setState(() {
                            _isCommitting = true;
                            _commitError = null;
                          });
                          try {
                            await ref
                                .read(activeSessionProvider.notifier)
                                .commitSession();
                            if (context.mounted) {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() {
                                _isCommitting = false;
                                _commitError = 'Commit failed. Tap to retry.';
                              });
                            }
                          }
                        },
                  child: Text(_isCommitting ? 'SAVING...' : 'DONE'),
                ),
              ],
              if (widget.isRecovery) ...[
                ElevatedButton(
                  onPressed: () async {
                    // Recovery: no active session state — call DAO directly
                    await ref
                        .read(sessionDaoProvider)
                        .commitSession(widget.sessionId);
                    ref.invalidate(historyProvider);
                    ref.invalidate(settingsProvider);
                    if (context.mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  child: const Text('SAVE SESSION'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () async {
                    await ref
                        .read(sessionDaoProvider)
                        .discardSession(widget.sessionId);
                    ref.invalidate(inProgressSessionProvider);
                    if (context.mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  child: Text('DISCARD',
                      style: TextStyle(color: AugustaTheme.textSecondary)),
                ),
              ],
              if (widget.isReadOnly && !widget.isRecovery)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('BACK',
                      style: TextStyle(color: AugustaTheme.gold)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _StatRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AugustaTheme.surface,
        border: Border(top: BorderSide(color: AugustaTheme.gold, width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Stat(label: 'SWINGS', value: '${stats['count']}'),
          _Stat(
              label: 'PEAK',
              value: (stats['peak'] as double).toStringAsFixed(1)),
          _Stat(
              label: 'AVG',
              value: (stats['avg'] as double).toStringAsFixed(1)),
          _Stat(
            label: 'CONSISTENCY',
            value: stats['consistency'] != null
                ? (stats['consistency'] as double).toStringAsFixed(0)
                : '---',
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AugustaTheme.gold,
              letterSpacing: 2,
            )),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AugustaTheme.textPrimary,
            )),
      ],
    );
  }
}
