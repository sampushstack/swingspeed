import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../providers/database_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/history_provider.dart';
import '../providers/session_provider.dart';
import '../theme/augusta_theme.dart';
import 'active_session_screen.dart';
import 'session_summary_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final historyAsync = ref.watch(historyProvider);
    final inProgressAsync = ref.watch(inProgressSessionProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App title
              Text(
                'SWINGSPEED',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AugustaTheme.gold,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Personal best
              settingsAsync.when(
                data: (settings) => _PersonalBestCard(
                    peakMph: settings.allTimePeakMph),
                loading: () => const SizedBox(height: 80),
                error: (_, __) => const SizedBox(),
              ),
              const SizedBox(height: 24),

              // Recovery banner
              inProgressAsync.when(
                data: (session) {
                  if (session == null) return const SizedBox();
                  return _RecoveryBanner(
                    sessionDate: DateTime.fromMillisecondsSinceEpoch(
                        session.date),
                    onResume: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SessionSummaryScreen(
                          sessionId: session.id,
                          isRecovery: true,
                        ),
                      ),
                    ),
                    onDiscard: () async {
                      await ref.read(sessionDaoProvider).discardSession(
                          session.id);
                      ref.invalidate(inProgressSessionProvider);
                    },
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),

              // Recent sessions
              Expanded(
                child: historyAsync.when(
                  data: (sessions) {
                    if (sessions.isEmpty) {
                      return Center(
                        child: Text(
                          'No sessions yet.\nStart swinging!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AugustaTheme.textSecondary,
                            fontFamily: 'Inter',
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: sessions.length > 5 ? 5 : sessions.length,
                      itemBuilder: (_, i) => _SessionListTile(
                        session: sessions[i],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SessionSummaryScreen(
                              sessionId: sessions[i].id,
                              isReadOnly: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox(),
                ),
              ),

              // Start session button
              inProgressAsync.when(
                data: (inProgress) => ElevatedButton(
                  onPressed: inProgress != null
                      ? null
                      : () async {
                          await ref
                              .read(activeSessionProvider.notifier)
                              .startSession();
                          if (context.mounted) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const ActiveSessionScreen(),
                              fullscreenDialog: true,
                            ));
                          }
                        },
                  child: const Text('START SESSION'),
                ),
                loading: () => const ElevatedButton(
                  onPressed: null,
                  child: Text('START SESSION'),
                ),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonalBestCard extends StatelessWidget {
  final double peakMph;
  const _PersonalBestCard({required this.peakMph});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AugustaTheme.surface,
        border: Border(top: BorderSide(color: AugustaTheme.gold, width: 2)),
      ),
      child: Column(
        children: [
          Text('PERSONAL BEST',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AugustaTheme.gold,
                letterSpacing: 4,
              )),
          const SizedBox(height: 8),
          Text(
            peakMph > 0 ? '${peakMph.toStringAsFixed(1)} mph' : '---',
            style: const TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AugustaTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecoveryBanner extends StatelessWidget {
  final DateTime sessionDate;
  final VoidCallback onResume;
  final VoidCallback onDiscard;
  const _RecoveryBanner({
    required this.sessionDate,
    required this.onResume,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AugustaTheme.surface,
        border: Border.all(color: AugustaTheme.gold.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Text(
            'Unfinished session from ${sessionDate.month}/${sessionDate.day}',
            style: TextStyle(color: AugustaTheme.textPrimary, fontFamily: 'Inter'),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: onResume,
                child: Text('RESUME', style: TextStyle(color: AugustaTheme.gold)),
              ),
              TextButton(
                onPressed: onDiscard,
                child: Text('DISCARD', style: TextStyle(color: AugustaTheme.textSecondary)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionListTile extends StatelessWidget {
  final Session session;
  final VoidCallback onTap;
  const _SessionListTile({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(session.date);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AugustaTheme.surface,
          border: Border(
              left: BorderSide(color: AugustaTheme.gold, width: 2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${date.month}/${date.day}/${date.year}',
              style: TextStyle(
                  color: AugustaTheme.textPrimary, fontFamily: 'Inter'),
            ),
            Text(
              '${session.swingCount} swings',
              style: TextStyle(
                  color: AugustaTheme.textSecondary, fontFamily: 'Inter'),
            ),
            Text(
              '${session.peakSpeedMph.toStringAsFixed(1)} mph',
              style: TextStyle(
                color: AugustaTheme.gold,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
