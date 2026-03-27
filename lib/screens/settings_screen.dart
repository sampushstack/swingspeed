import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/club_types.dart';
import '../providers/database_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/augusta_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _showAdvanced = false;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: settingsAsync.when(
            data: (settings) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('SETTINGS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AugustaTheme.gold,
                        letterSpacing: 3,
                      ),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 32),

                  // Swing mode toggle
                  Text('SWING MODE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AugustaTheme.gold,
                        letterSpacing: 2,
                      )),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await ref.read(settingsDaoProvider).updateSwingMode('club');
                            ref.invalidate(settingsProvider);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: settings.swingMode == 'club'
                                  ? AugustaTheme.gold
                                  : AugustaTheme.surface,
                              border: Border.all(
                                color: AugustaTheme.gold,
                                width: settings.swingMode == 'club' ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.sports_golf,
                                    color: settings.swingMode == 'club'
                                        ? AugustaTheme.background
                                        : AugustaTheme.textSecondary,
                                    size: 24),
                                const SizedBox(height: 6),
                                Text('CLUB MOUNT',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      color: settings.swingMode == 'club'
                                          ? AugustaTheme.background
                                          : AugustaTheme.textSecondary,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            await ref.read(settingsDaoProvider).updateSwingMode('freehand');
                            ref.invalidate(settingsProvider);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: settings.swingMode == 'freehand'
                                  ? AugustaTheme.gold
                                  : AugustaTheme.surface,
                              border: Border.all(
                                color: AugustaTheme.gold,
                                width: settings.swingMode == 'freehand' ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.back_hand_outlined,
                                    color: settings.swingMode == 'freehand'
                                        ? AugustaTheme.background
                                        : AugustaTheme.textSecondary,
                                    size: 24),
                                const SizedBox(height: 6),
                                Text('FREEHAND',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                      color: settings.swingMode == 'freehand'
                                          ? AugustaTheme.background
                                          : AugustaTheme.textSecondary,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    settings.swingMode == 'club'
                        ? 'Phone attached to club shaft'
                        : 'Hold phone in hand — no club needed',
                    style: TextStyle(
                        color: AugustaTheme.textSecondary,
                        fontFamily: 'Inter',
                        fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Pivot distance
                  Text(
                      settings.swingMode == 'club'
                          ? 'CLUB LENGTH OFFSET'
                          : 'ARM LENGTH',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AugustaTheme.gold,
                        letterSpacing: 2,
                      )),
                  const SizedBox(height: 4),
                  Text(
                      settings.swingMode == 'club'
                          ? 'Distance from phone mount to club head'
                          : 'Distance from shoulder to phone in hand',
                      style: TextStyle(
                          color: AugustaTheme.textSecondary,
                          fontFamily: 'Inter',
                          fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('${settings.clubLengthOffsetM.toStringAsFixed(2)} m',
                          style: TextStyle(
                            color: AugustaTheme.textPrimary,
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      const Spacer(),
                      Text('0.1',
                          style: TextStyle(
                              color: AugustaTheme.textSecondary,
                              fontSize: 11)),
                      Expanded(
                        flex: 3,
                        child: Slider(
                          value: settings.clubLengthOffsetM,
                          min: 0.1,
                          max: 1.2,
                          divisions: 22,
                          activeColor: AugustaTheme.gold,
                          inactiveColor: AugustaTheme.surface,
                          onChanged: (v) async {
                            await ref
                                .read(settingsDaoProvider)
                                .updateClubOffset(v);
                            ref.invalidate(settingsProvider);
                          },
                        ),
                      ),
                      Text('1.2',
                          style: TextStyle(
                              color: AugustaTheme.textSecondary,
                              fontSize: 11)),
                    ],
                  ),

                  // Club type selector (freehand mode only)
                  if (settings.swingMode == 'freehand') ...[
                    const SizedBox(height: 24),
                    Text('ESTIMATE FOR CLUB',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AugustaTheme.gold,
                          letterSpacing: 2,
                        )),
                    const SizedBox(height: 4),
                    Text('Select a club to estimate club head speed from your hand speed',
                        style: TextStyle(
                            color: AugustaTheme.textSecondary,
                            fontFamily: 'Inter',
                            fontSize: 12)),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AugustaTheme.surface,
                        border: Border.all(color: AugustaTheme.gold.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: clubTypes.map((club) {
                          final isSelected = settings.selectedClubType == club.id;
                          return GestureDetector(
                            onTap: () async {
                              await ref.read(settingsDaoProvider).updateSelectedClubType(club.id);
                              ref.invalidate(settingsProvider);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSelected ? AugustaTheme.gold.withValues(alpha: 0.15) : null,
                                border: Border(
                                  bottom: BorderSide(color: AugustaTheme.background.withValues(alpha: 0.3), width: 1),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (isSelected)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: Icon(Icons.check, color: AugustaTheme.gold, size: 16),
                                        ),
                                      Text(club.name,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 14,
                                            color: isSelected ? AugustaTheme.gold : AugustaTheme.textPrimary,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          )),
                                    ],
                                  ),
                                  Text('${(club.shaftLengthM * 39.3701).toStringAsFixed(1)}"',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: AugustaTheme.textSecondary,
                                      )),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Builder(builder: (_) {
                      final club = getClubTypeById(settings.selectedClubType);
                      final effectiveR = settings.clubLengthOffsetM + (club?.shaftLengthM ?? 0);
                      return Text(
                        'Effective pivot: ${settings.clubLengthOffsetM.toStringAsFixed(2)}m arm + ${club?.shaftLengthM.toStringAsFixed(2) ?? '0'}m shaft = ${effectiveR.toStringAsFixed(2)}m',
                        style: TextStyle(
                          color: AugustaTheme.textSecondary,
                          fontFamily: 'Inter',
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      );
                    }),
                  ],

                  const SizedBox(height: 32),

                  // Advanced
                  GestureDetector(
                    onTap: () =>
                        setState(() => _showAdvanced = !_showAdvanced),
                    child: Row(
                      children: [
                        Text('ADVANCED',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AugustaTheme.gold,
                              letterSpacing: 2,
                            )),
                        const SizedBox(width: 8),
                        Icon(
                          _showAdvanced
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: AugustaTheme.gold,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  if (_showAdvanced) ...[
                    const SizedBox(height: 16),
                    _ThresholdSlider(
                      label: 'Start Threshold (rad/s)',
                      value: settings.swingStartThreshold,
                      min: 1.0,
                      max: 10.0,
                      onChanged: (v) async {
                        await ref
                            .read(settingsDaoProvider)
                            .updateThresholds(startThreshold: v);
                        ref.invalidate(settingsProvider);
                      },
                    ),
                    _ThresholdSlider(
                      label: 'End Threshold (rad/s)',
                      value: settings.swingEndThreshold,
                      min: 0.1,
                      max: 5.0,
                      onChanged: (v) async {
                        await ref
                            .read(settingsDaoProvider)
                            .updateThresholds(endThreshold: v);
                        ref.invalidate(settingsProvider);
                      },
                    ),
                    _ThresholdSlider(
                      label: 'Cooldown (ms)',
                      value: settings.cooldownMs.toDouble(),
                      min: 500,
                      max: 3000,
                      onChanged: (v) async {
                        await ref
                            .read(settingsDaoProvider)
                            .updateThresholds(cooldownMs: v.round());
                        ref.invalidate(settingsProvider);
                      },
                    ),
                  ],
                ],
              ),
            ),
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
        ),
      ),
    );
  }
}

class _ThresholdSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _ThresholdSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: TextStyle(
                      color: AugustaTheme.textSecondary,
                      fontFamily: 'Inter',
                      fontSize: 12)),
              Text(value.toStringAsFixed(1),
                  style: TextStyle(
                      color: AugustaTheme.textPrimary,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            activeColor: AugustaTheme.gold,
            inactiveColor: AugustaTheme.surface,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
