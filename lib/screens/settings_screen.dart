import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/cyberpunk_effects.dart';

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
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
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
              'Built in 36 hours with Amp AI',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'thephillipsequation llc',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
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
