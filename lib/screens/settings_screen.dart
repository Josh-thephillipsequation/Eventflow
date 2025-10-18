import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import '../providers/event_provider.dart';
import '../widgets/cyberpunk_effects.dart';
import 'onboarding_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isCyberpunk = themeProvider.isCyberpunkTheme;

    return Scaffold(
      appBar: AppBar(
        title: isCyberpunk
            ? const NeonPulseText(text: 'SETTINGS')
            : const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          _buildSectionHeader(context, '🎨 Appearance', isCyberpunk),
          const SizedBox(height: 16),
          _buildThemeSelector(context, themeProvider, isCyberpunk),

          const SizedBox(height: 32),

          // Help Section
          _buildSectionHeader(context, '❓ Help', isCyberpunk),
          const SizedBox(height: 16),
          _buildHelpCard(context, isCyberpunk),

          const SizedBox(height: 32),

          // Data Management Section
          _buildSectionHeader(context, '📂 Data', isCyberpunk),
          const SizedBox(height: 16),
          _buildDataManagementCard(context, isCyberpunk),
          const SizedBox(height: 16),
          _buildSampleDataCard(context, isCyberpunk),

          const SizedBox(height: 32),

          // About Section
          _buildSectionHeader(context, 'ℹ️ About', isCyberpunk),
          const SizedBox(height: 16),
          _buildAboutCard(context, isCyberpunk),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, bool isCyberpunk) {
    final textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: isCyberpunk ? 1.5 : null,
        );

    if (isCyberpunk) {
      return NeonPulseText(
        text: title.toUpperCase(),
        style: textStyle,
      );
    }

    return Text(
      title,
      style: textStyle,
    );
  }

  Widget _buildThemeSelector(
      BuildContext context, ThemeProvider themeProvider, bool isCyberpunk) {
    Widget card = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...AppThemeType.values.map((theme) {
              final isSelected = themeProvider.currentTheme == theme;
              return _buildThemeOption(
                context,
                theme,
                isSelected,
                themeProvider,
                isCyberpunk,
              );
            }),
          ],
        ),
      ),
    );

    if (isCyberpunk) {
      return NeonBorderGlow(
        borderRadius: 4,
        child: card,
      );
    }

    return card;
  }

  Widget _buildThemeOption(
    BuildContext context,
    AppThemeType theme,
    bool isSelected,
    ThemeProvider themeProvider,
    bool isCyberpunk,
  ) {
    final emoji = themeProvider.getThemeEmoji(theme);
    final name = themeProvider.getThemeName(theme);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => themeProvider.setTheme(theme),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context, bool isCyberpunk) {
    Widget card = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tutorial',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Want to see the app tour again?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                // Reset onboarding flag
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('onboarding_complete', false);

                if (!context.mounted) return;

                // Navigate to onboarding
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                );

                // Set it back to complete after viewing
                if (context.mounted) {
                  await prefs.setBool('onboarding_complete', true);
                }
              },
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('View Tutorial Again'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );

    if (isCyberpunk) {
      return NeonBorderGlow(
        borderRadius: 4,
        child: card,
      );
    }

    return card;
  }

  Widget _buildAboutCard(BuildContext context, bool isCyberpunk) {
    Widget card = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EventFlow',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Built using Amp AI',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'thephillipsequation llc',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5),
                  ),
            ),
          ],
        ),
      ),
    );

    if (isCyberpunk) {
      return NeonBorderGlow(
        borderRadius: 4,
        child: card,
      );
    }

    return card;
  }

  Widget _buildDataManagementCard(BuildContext context, bool isCyberpunk) {
    Widget card = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clear All Data',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Remove all imported events and reset app to initial state.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                // Show confirmation dialog
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Data?'),
                    content: const Text(
                      'This will remove all imported events and reset the app. This action cannot be undone.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text('Clear Data'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && context.mounted) {
                  // Clear data using EventProvider
                  final eventProvider =
                      Provider.of<EventProvider>(context, listen: false);
                  await eventProvider.clearAllData();

                  // Show confirmation
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All data cleared successfully'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear All Data'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );

    if (isCyberpunk) {
      return NeonBorderGlow(
        borderRadius: 4,
        child: card,
      );
    }

    return card;
  }

  Widget _buildSampleDataCard(BuildContext context, bool isCyberpunk) {
    Widget card = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sample Conference Data',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Import sample conference data to try out EventFlow features.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  // Import using EventProvider and calendar service
                  final eventProvider =
                      Provider.of<EventProvider>(context, listen: false);
                  await eventProvider
                      .loadCalendarFromAsset('assets/sample_conference.ics');

                  if (!context.mounted) return;

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Sample conference data imported successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;

                  // Show error dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Import Failed'),
                      content: Text(
                        'Could not import sample data: ${e.toString()}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.download_outlined),
              label: const Text('Import Sample Conference'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );

    if (isCyberpunk) {
      return NeonBorderGlow(
        borderRadius: 4,
        child: card,
      );
    }

    return card;
  }
}
