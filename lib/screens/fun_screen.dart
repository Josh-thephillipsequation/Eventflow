import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/event_provider.dart';
import '../models/calendar_event.dart';

class FunScreen extends StatefulWidget {
  const FunScreen({super.key});

  @override
  State<FunScreen> createState() => _FunScreenState();
}

class _FunScreenState extends State<FunScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _generatedTitle = '';
  String _generatedAbstract = '';
  bool _isGenerating = false;

  // Product generator state
  String _generatedProductName = '';
  String _generatedTagline = '';
  bool _isGeneratingProduct = false;

  // Bingo generator state
  List<String> _bingoSquares = [];
  List<bool> _bingoMarked = [];
  bool _isGeneratingBingo = false;
  bool _hasBingo = false;

  final Random _random = Random();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        final events = provider.allEvents;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      size: 48,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fun Zone',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Generate creative AI-powered content based on your event data!',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (events.isEmpty) ...[
                // No data state
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Icon(Icons.data_usage,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No Event Data Available',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Import a calendar first to generate AI-powered talk proposals based on your event themes!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                // Fun Tools Section
                Column(
                  children: [
                    Row(
                      children: [
                        // Talk Generator
                        Expanded(
                          child: Card(
                            child: InkWell(
                              onTap: () => _generateTalk(events),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.mic_rounded,
                                      size: 32,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Talk Generator',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Generate talk proposals',
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Product Generator
                        Expanded(
                          child: Card(
                            child: InkWell(
                              onTap: () => _generateProduct(events),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_rounded,
                                      size: 32,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Product Ideas',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Generate product names',
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Bingo Generator (Full Width)
                    Card(
                      child: InkWell(
                        onTap: () => _generateBingo(events),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.grid_on_rounded,
                                size: 32,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Conference Bingo',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Generate a bingo card from your event topics',
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Input section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Information',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Your Name',
                            hintText: 'e.g., John Smith',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _isGenerating
                                        ? null
                                        : () => _generateTalk(events),
                                    icon: _isGenerating
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.mic_rounded),
                                    label: Text(_isGenerating
                                        ? 'Generating...'
                                        : 'Talk Proposal'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _isGeneratingProduct
                                        ? null
                                        : () => _generateProduct(events),
                                    icon: _isGeneratingProduct
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.lightbulb_rounded),
                                    label: Text(_isGeneratingProduct
                                        ? 'Generating...'
                                        : 'Product Idea'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Bingo Generator Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isGeneratingBingo
                                    ? null
                                    : () => _generateBingo(events),
                                icon: _isGeneratingBingo
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Icon(Icons.grid_on_rounded),
                                label: Text(_isGeneratingBingo
                                    ? 'Generating...'
                                    : 'Conference Bingo'),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  foregroundColor: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Generated Bingo content
                if (_bingoSquares.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.grid_on,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Conference Bingo Card',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: _copyBingoToClipboard,
                                icon: const Icon(Icons.copy),
                                tooltip: 'Copy to clipboard',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 5x5 Bingo Grid
                          AspectRatio(
                            aspectRatio: 1.0,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                              itemCount: 25,
                              itemBuilder: (context, index) {
                                final isCenter = index == 12; // Center square
                                final text = isCenter
                                    ? 'FREE'
                                    : _bingoSquares[
                                        index < 12 ? index : index - 1];
                                final isMarked = isCenter
                                    ? true
                                    : _bingoMarked[
                                        index < 12 ? index : index - 1];

                                return GestureDetector(
                                  onTap: isCenter
                                      ? null
                                      : () {
                                          setState(() {
                                            final realIndex =
                                                index < 12 ? index : index - 1;
                                            _bingoMarked[realIndex] =
                                                !_bingoMarked[realIndex];
                                          });

                                          // Check for bingo after marking
                                          if (!_hasBingo && _checkForBingo()) {
                                            _celebrateBingo();
                                          }
                                        },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isMarked
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isMarked
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .outline
                                                .withValues(alpha: 0.3),
                                        width: isMarked ? 2 : 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: isMarked
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                  fontWeight: isMarked
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  fontSize: 8,
                                                ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 12),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onTertiaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Tap squares to mark them as you hear these topics during the conference!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onTertiaryContainer,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Generated Product content
                if (_generatedProductName.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Generated Product Idea',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: _copyProductToClipboard,
                                icon: const Icon(Icons.copy),
                                tooltip: 'Copy to clipboard',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Product Name
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Name',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _generatedProductName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Tagline
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tagline',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _generatedTagline,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Generated Talk content
                if (_generatedTitle.isNotEmpty) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Generated Talk Proposal',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: _copyToClipboard,
                                icon: const Icon(Icons.copy),
                                tooltip: 'Copy to clipboard',
                              ),
                              IconButton(
                                onPressed: _shareProposal,
                                icon: const Icon(Icons.share),
                                tooltip: 'Share proposal',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Title
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Title',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _generatedTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Abstract
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Abstract',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _generatedAbstract,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Disclaimer
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'This is a fun AI-generated proposal based on your event data. Results may be hilariously creative! 🤖',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  void _generateTalk(List<CalendarEvent> events) {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first!')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    // Simulate AI processing delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      final analysis = _analyzeEvents(events);
      final title = _generateTitle(analysis, _nameController.text.trim());
      final abstract =
          _generateAbstract(title, analysis, _nameController.text.trim());

      setState(() {
        _generatedTitle = title;
        _generatedAbstract = abstract;
        _isGenerating = false;
      });
    });
  }

  Map<String, dynamic> _analyzeEvents(List<CalendarEvent> events) {
    // Extract common themes/topics
    final allWords = <String>[];
    final technologies = <String>[];
    final actions = <String>[];

    for (final event in events) {
      final words = event.title
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .split(' ')
          .where((word) => word.length > 2)
          .where((word) => !_commonWords.contains(word));

      allWords.addAll(words);

      // Look for tech terms
      for (final word in words) {
        if (_techTerms.contains(word)) {
          technologies.add(word);
        }
        if (_actionWords.contains(word)) {
          actions.add(word);
        }
      }
    }

    // Find most common themes
    final wordCount = <String, int>{};
    for (final word in allWords) {
      wordCount[word] = (wordCount[word] ?? 0) + 1;
    }

    final topWords = wordCount.entries.where((e) => e.value > 1).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'topWords': topWords.take(5).map((e) => e.key).toList(),
      'technologies': technologies.toSet().toList(),
      'actions': actions.toSet().toList(),
      'eventCount': events.length,
    };
  }

  String _generateTitle(Map<String, dynamic> analysis, String name) {
    final topWords = analysis['topWords'] as List<String>;
    final technologies = analysis['technologies'] as List<String>;
    final actions = analysis['actions'] as List<String>;

    // Fun title templates
    final templates = [
      '{topic}: {action} Your Way to Success',
      'How to {action} {topic} in {number} Easy Steps',
      'The Future of {topic}: A {name} Perspective',
      '{topic} {tech}: {action} Beyond the Hype',
      'From Zero to {topic} Hero: My Journey',
      '{action} {topic} Like a Pro: Advanced Techniques',
      'The {adjective} Guide to {topic} and {tech}',
      'Breaking Down {topic}: What Every {role} Should Know',
      '{topic} Revolution: How {tech} Changes Everything',
      'Mastering {topic}: Tales from the {adjective} Side',
    ];

    final template = templates[_random.nextInt(templates.length)];
    final primaryTopic = topWords.isNotEmpty ? topWords.first : 'Innovation';
    final tech = technologies.isNotEmpty
        ? technologies[_random.nextInt(technologies.length)]
        : 'AI';
    final action = actions.isNotEmpty
        ? actions[_random.nextInt(actions.length)]
        : 'Transform';

    return template
        .replaceAll('{topic}', _capitalize(primaryTopic))
        .replaceAll('{tech}', _capitalize(tech))
        .replaceAll('{action}', _capitalize(action))
        .replaceAll('{name}', name.split(' ').first)
        .replaceAll('{number}', '${_random.nextInt(7) + 3}')
        .replaceAll(
            '{adjective}', _adjectives[_random.nextInt(_adjectives.length)])
        .replaceAll('{role}', _roles[_random.nextInt(_roles.length)]);
  }

  String _generateAbstract(
      String title, Map<String, dynamic> analysis, String name) {
    final topWords = analysis['topWords'] as List<String>;
    final technologies = analysis['technologies'] as List<String>;
    final eventCount = analysis['eventCount'] as int;

    final openings = [
      'In this groundbreaking session,',
      'Join me for an exciting journey into',
      'Discover the secrets of',
      'Unlock the potential of',
      'Explore the cutting-edge world of',
    ];

    final middles = [
      'drawing from extensive research and real-world experience',
      'based on insights from $eventCount industry events',
      'leveraging proven strategies and innovative approaches',
      'combining traditional wisdom with modern innovation',
      'using data-driven methodologies and creative thinking',
    ];

    final endings = [
      'Attendees will leave with actionable insights and practical tools.',
      'Perfect for professionals looking to stay ahead of the curve.',
      'A must-attend session for anyone serious about innovation.',
      'Prepare to challenge your assumptions and expand your horizons.',
      'Don\'t miss this opportunity to transform your approach.',
    ];

    final primaryTopic = topWords.isNotEmpty ? topWords.first : 'innovation';
    final tech = technologies.isNotEmpty ? technologies.first : 'technology';

    final opening = openings[_random.nextInt(openings.length)];
    final middle = middles[_random.nextInt(middles.length)];
    final ending = endings[_random.nextInt(endings.length)];

    return '$opening $name will share invaluable insights about ${_capitalize(primaryTopic)} and how $tech is revolutionizing the industry. This presentation offers a unique perspective, $middle that have shaped the modern landscape.\n\nWe\'ll explore practical applications, common pitfalls, and emerging trends that every professional should know. $ending';
  }

  String _capitalize(String word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }

  void _copyToClipboard() {
    final content = 'Title: $_generatedTitle\n\nAbstract: $_generatedAbstract';
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  void _shareProposal() {
    // In a real app, this would use the share package
    _copyToClipboard();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Content copied to clipboard for sharing!')),
    );
  }

  void _generateProduct(List<CalendarEvent> events) {
    setState(() {
      _isGeneratingProduct = true;
    });

    // Simulate AI processing delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      final analysis = _analyzeProductOpportunities(events);
      final productName = _generateProductName(analysis);
      final tagline = _generateProductTagline(productName, analysis);

      setState(() {
        _generatedProductName = productName;
        _generatedTagline = tagline;
        _isGeneratingProduct = false;
      });
    });
  }

  Map<String, dynamic> _analyzeProductOpportunities(
      List<CalendarEvent> events) {
    final problems = <String>[];
    final solutions = <String>[];
    final industries = <String>[];

    for (final event in events) {
      final text = '${event.title} ${event.description}'.toLowerCase();

      // Extract problem indicators
      final problemWords = [
        'problem',
        'challenge',
        'issue',
        'difficulty',
        'struggle',
        'pain',
        'bottleneck',
        'inefficient'
      ];
      for (final word in problemWords) {
        if (text.contains(word)) {
          problems.add(word);
        }
      }

      // Extract solution indicators
      final solutionWords = [
        'solution',
        'fix',
        'improve',
        'optimize',
        'automate',
        'streamline',
        'enhance',
        'accelerate'
      ];
      for (final word in solutionWords) {
        if (text.contains(word)) {
          solutions.add(word);
        }
      }

      // Extract industry terms
      final industryTerms = [
        'ai',
        'machine learning',
        'data',
        'cloud',
        'mobile',
        'web',
        'fintech',
        'healthcare',
        'education',
        'retail'
      ];
      for (final term in industryTerms) {
        if (text.contains(term)) {
          industries.add(term);
        }
      }
    }

    return {
      'problems': problems.toSet().toList(),
      'solutions': solutions.toSet().toList(),
      'industries': industries.toSet().toList(),
      'eventCount': events.length,
    };
  }

  String _generateProductName(Map<String, dynamic> analysis) {
    final solutions = analysis['solutions'] as List<String>;
    final industries = analysis['industries'] as List<String>;

    final prefixes = [
      'Smart',
      'Quick',
      'Easy',
      'Auto',
      'Instant',
      'Pro',
      'Super',
      'Mega',
      'Ultra',
      'Hyper'
    ];
    final suffixes = [
      'ly',
      'ify',
      'Hub',
      'Pro',
      'Flow',
      'Sync',
      'Wave',
      'Lab',
      'Zone',
      'Works'
    ];

    final industry =
        industries.isNotEmpty ? _capitalize(industries.first) : 'Tech';
    final solution =
        solutions.isNotEmpty ? _capitalize(solutions.first) : 'Solve';
    final prefix = prefixes[_random.nextInt(prefixes.length)];
    final suffix = suffixes[_random.nextInt(suffixes.length)];

    final patterns = [
      '$prefix$industry$suffix',
      '$solution$suffix',
      '$industry$solution',
      '$prefix${solution}r',
      '${industry}Genie',
      '${solution}Master',
    ];

    return patterns[_random.nextInt(patterns.length)];
  }

  String _generateProductTagline(
      String productName, Map<String, dynamic> analysis) {
    final industries = analysis['industries'] as List<String>;
    final eventCount = analysis['eventCount'] as int;

    final industry = industries.isNotEmpty ? industries.first : 'technology';

    final taglines = [
      'Revolutionizing $industry, one solution at a time',
      'The future of $industry is here',
      'Making $industry simple, smart, and powerful',
      'Where innovation meets $industry excellence',
      'Transforming how you think about $industry',
      'Built for the modern $industry professional',
      'The smart way to handle $industry challenges',
      'Inspired by $eventCount industry insights',
    ];

    return taglines[_random.nextInt(taglines.length)];
  }

  void _generateBingo(List<CalendarEvent> events) {
    setState(() {
      _isGeneratingBingo = true;
      _hasBingo = false;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      final bingo = _createBingoSquares(events);
      setState(() {
        _bingoSquares = bingo;
        _bingoMarked =
            List.filled(24, false); // 24 squares (excluding center FREE)
        _isGeneratingBingo = false;
        _hasBingo = false;
      });
    });
  }

  List<String> _createBingoSquares(List<CalendarEvent> events) {
    final phrases = <String>[];

    // Extract common conference phrases
    final bingoTerms = [
      'AI/ML',
      'Cloud Native',
      'Microservices',
      'DevOps',
      'Blockchain',
      'APIs',
      'Digital Transformation',
      'Agile',
      'Innovation',
      'Security',
      'Data Science',
      'Machine Learning',
      'Best Practices',
      'Scalability',
      'Architecture',
      'Framework',
      'Platform',
      'Automation',
      'Analytics',
      'User Experience',
      'Performance',
      'Integration',
      'Open Source',
      'Strategy',
      'Leadership',
      'Future of',
      'Next Generation'
    ];

    // Add event-specific terms
    for (final event in events) {
      final words = event.title
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '')
          .split(' ')
          .where((word) => word.length > 3)
          .where((word) => !_commonWords.contains(word));

      phrases.addAll(words.map((w) => _capitalize(w)));
    }

    // Combine generic terms with event-specific ones
    final allTerms = [...bingoTerms, ...phrases.toSet()];
    allTerms.shuffle(_random);

    // Return 24 squares (center is FREE)
    return allTerms.take(24).toList();
  }

  void _copyProductToClipboard() {
    final content =
        'Product: $_generatedProductName\nTagline: $_generatedTagline';
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product idea copied to clipboard!')),
    );
  }

  void _copyBingoToClipboard() {
    final content =
        'Conference Bingo Card:\n\n${_bingoSquares.asMap().entries.map((e) {
      final index = e.key;
      final square = e.value;
      if ((index + 1) % 5 == 0) return '$square\n';
      return square.padRight(15);
    }).join('')}';

    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bingo card copied to clipboard!')),
    );
  }

  bool _checkForBingo() {
    if (_bingoMarked.length != 24) return false;

    // Convert to 5x5 grid (excluding center which is always marked)
    List<List<bool>> grid = List.generate(
        5,
        (row) => List.generate(5, (col) {
              final index = row * 5 + col;
              if (index == 12) return true; // Center FREE square
              return _bingoMarked[index < 12 ? index : index - 1];
            }));

    // Check rows
    for (int row = 0; row < 5; row++) {
      if (grid[row].every((marked) => marked)) return true;
    }

    // Check columns
    for (int col = 0; col < 5; col++) {
      if (List.generate(5, (row) => grid[row][col]).every((marked) => marked)) {
        return true;
      }
    }

    // Check diagonals
    if (List.generate(5, (i) => grid[i][i]).every((marked) => marked)) {
      return true;
    }
    if (List.generate(5, (i) => grid[i][4 - i]).every((marked) => marked)) {
      return true;
    }

    return false;
  }

  void _celebrateBingo() {
    setState(() {
      _hasBingo = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.celebration,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'BINGO!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Congratulations!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You got a bingo! Time to celebrate your conference achievements.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Generate new bingo card
              final events =
                  Provider.of<EventProvider>(context, listen: false).allEvents;
              _generateBingo(events);
            },
            child: const Text('New Game'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Playing'),
          ),
        ],
      ),
    );
  }

  // Data sets for generating creative content
  static const Set<String> _commonWords = {
    'the',
    'and',
    'for',
    'are',
    'but',
    'not',
    'you',
    'all',
    'can',
    'had',
    'her',
    'was',
    'one',
    'our',
    'out',
    'day',
    'get',
    'has',
    'him',
    'his',
    'how',
    'its',
    'may',
    'new',
    'now',
    'old',
    'see',
    'two',
    'who',
    'boy',
    'did',
    'she',
    'use',
    'way',
    'what',
    'with',
    'have',
    'from',
    'they',
    'know',
    'want',
    'been',
    'good',
    'much',
    'some',
    'time',
    'very',
    'when',
    'come',
    'here',
    'just',
    'like',
    'long',
  };

  static const Set<String> _techTerms = {
    'ai',
    'ml',
    'data',
    'cloud',
    'api',
    'web',
    'mobile',
    'app',
    'software',
    'platform',
    'digital',
    'analytics',
    'automation',
    'blockchain',
    'iot',
    'security',
    'database',
    'frontend',
    'backend',
    'framework',
    'algorithm',
    'neural',
    'machine',
    'learning',
    'artificial',
    'intelligence',
  };

  static const Set<String> _actionWords = {
    'build',
    'create',
    'develop',
    'design',
    'implement',
    'optimize',
    'scale',
    'deploy',
    'manage',
    'analyze',
    'transform',
    'integrate',
    'innovate',
    'automate',
    'enhance',
    'improve',
    'solve',
  };

  static const List<String> _adjectives = [
    'Ultimate',
    'Complete',
    'Comprehensive',
    'Advanced',
    'Modern',
    'Innovative',
    'Strategic',
    'Practical',
    'Essential',
    'Revolutionary',
    'Cutting-edge',
    'Next-generation',
  ];

  static const List<String> _roles = [
    'Developer',
    'Designer',
    'Manager',
    'Leader',
    'Professional',
    'Innovator',
    'Strategist',
    'Analyst',
    'Engineer',
    'Architect',
    'Consultant',
    'Specialist',
  ];
}
