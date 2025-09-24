import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../providers/event_provider.dart';
import '../models/calendar_event.dart';

class TalkGeneratorScreen extends StatefulWidget {
  const TalkGeneratorScreen({super.key});

  @override
  State<TalkGeneratorScreen> createState() => _TalkGeneratorScreenState();
}

class _TalkGeneratorScreenState extends State<TalkGeneratorScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _generatedTitle = '';
  String _generatedAbstract = '';
  bool _isGenerating = false;
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
              // Header with fun emoji
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
                    const Text('🎤✨', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text(
                      'AI Talk Generator',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Generate fun, AI-powered talk proposals based on your event data!',
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
                        const Icon(Icons.data_usage, size: 64, color: Colors.grey),
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isGenerating ? null : () => _generateTalk(events),
                            icon: _isGenerating 
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.auto_awesome),
                            label: Text(_isGenerating ? 'Generating...' : 'Generate Talk Proposal'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Generated content
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
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Title',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _generatedTitle,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Abstract',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                              color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'This is a fun AI-generated proposal based on your event data. Results may be hilariously creative! 🤖',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSecondaryContainer,
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
      final abstract = _generateAbstract(title, analysis, _nameController.text.trim());

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
      final words = event.title.toLowerCase()
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

    final topWords = wordCount.entries
        .where((e) => e.value > 1)
        .toList()
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
    final tech = technologies.isNotEmpty ? technologies[_random.nextInt(technologies.length)] : 'AI';
    final action = actions.isNotEmpty ? actions[_random.nextInt(actions.length)] : 'Transform';
    
    return template
        .replaceAll('{topic}', _capitalize(primaryTopic))
        .replaceAll('{tech}', _capitalize(tech))
        .replaceAll('{action}', _capitalize(action))
        .replaceAll('{name}', name.split(' ').first)
        .replaceAll('{number}', '${_random.nextInt(7) + 3}')
        .replaceAll('{adjective}', _adjectives[_random.nextInt(_adjectives.length)])
        .replaceAll('{role}', _roles[_random.nextInt(_roles.length)]);
  }

  String _generateAbstract(String title, Map<String, dynamic> analysis, String name) {
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

  // Data sets for generating creative content
  static const Set<String> _commonWords = {
    'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'had', 'her', 'was', 'one', 'our',
    'out', 'day', 'get', 'has', 'him', 'his', 'how', 'its', 'may', 'new', 'now', 'old', 'see', 'two',
    'who', 'boy', 'did', 'she', 'use', 'way', 'what', 'with', 'have', 'from', 'they', 'know', 'want',
    'been', 'good', 'much', 'some', 'time', 'very', 'when', 'come', 'here', 'just', 'like', 'long',
  };

  static const Set<String> _techTerms = {
    'ai', 'ml', 'data', 'cloud', 'api', 'web', 'mobile', 'app', 'software', 'platform', 'digital',
    'analytics', 'automation', 'blockchain', 'iot', 'security', 'database', 'frontend', 'backend',
    'framework', 'algorithm', 'neural', 'machine', 'learning', 'artificial', 'intelligence',
  };

  static const Set<String> _actionWords = {
    'build', 'create', 'develop', 'design', 'implement', 'optimize', 'scale', 'deploy', 'manage',
    'analyze', 'transform', 'integrate', 'innovate', 'automate', 'enhance', 'improve', 'solve',
  };

  static const List<String> _adjectives = [
    'Ultimate', 'Complete', 'Comprehensive', 'Advanced', 'Modern', 'Innovative', 'Strategic',
    'Practical', 'Essential', 'Revolutionary', 'Cutting-edge', 'Next-generation',
  ];

  static const List<String> _roles = [
    'Developer', 'Designer', 'Manager', 'Leader', 'Professional', 'Innovator', 'Strategist',
    'Analyst', 'Engineer', 'Architect', 'Consultant', 'Specialist',
  ];
}
