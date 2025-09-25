import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../models/calendar_event.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String _timeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        final allEvents = provider.allEvents;

        if (allEvents.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.insights, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No data to analyze',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Import a calendar to see event insights',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Filter events based on time filter
        final now = DateTime.now();
        final filteredEvents = allEvents.where((event) {
          switch (_timeFilter) {
            case 'upcoming':
              return event.endTime.toLocal().isAfter(now);
            case 'past':
              return event.endTime.toLocal().isBefore(now);
            case 'all':
            default:
              return true;
          }
        }).toList();

        // Calculate insights
        final insights = _calculateInsights(filteredEvents);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time filter selector
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('Analyze: '),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _timeFilter,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                              value: 'all', child: Text('All Events')),
                          DropdownMenuItem(
                              value: 'upcoming',
                              child: Text('Upcoming Events')),
                          DropdownMenuItem(
                              value: 'past', child: Text('Past Events')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _timeFilter = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Overview Stats
              _buildOverviewSection(context, filteredEvents, insights),

              const SizedBox(height: 24),

              // Time Analysis
              _buildTimeAnalysisSection(context, insights),

              const SizedBox(height: 24),

              // Word Frequency Analysis
              _buildWordAnalysisSection(context, insights),

              const SizedBox(height: 24),

              // Priority Distribution
              _buildPriorityAnalysisSection(context, filteredEvents),
            ],
          ),
        );
      },
    );
  }

  Map<String, dynamic> _calculateInsights(List<CalendarEvent> events) {
    if (events.isEmpty) return {};

    // Calculate total duration
    Duration totalDuration = Duration.zero;
    for (final event in events) {
      totalDuration += event.endTime.difference(event.startTime);
    }

    // Calculate word frequencies from titles
    final Map<String, int> wordFreq = {};
    for (final event in events) {
      final words = event.title
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
          .split(' ')
          .where((word) => word.length > 2) // Filter out short words
          .where((word) => !_commonWords.contains(word)); // Filter common words

      for (final word in words) {
        wordFreq[word] = (wordFreq[word] ?? 0) + 1;
      }
    }

    // Get top words
    final topWords = wordFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Calculate daily distribution
    final Map<String, int> dailyCount = {};
    for (final event in events) {
      final dayKey = DateFormat('EEEE').format(event.startTime.toLocal());
      dailyCount[dayKey] = (dailyCount[dayKey] ?? 0) + 1;
    }

    // Calculate hourly distribution
    final Map<int, int> hourlyCount = {};
    for (final event in events) {
      final hour = event.startTime.toLocal().hour;
      hourlyCount[hour] = (hourlyCount[hour] ?? 0) + 1;
    }

    return {
      'totalDuration': totalDuration,
      'averageDuration': Duration(
          milliseconds: events.isNotEmpty
              ? totalDuration.inMilliseconds ~/ events.length
              : 0),
      'topWords': topWords.take(10).toList(),
      'dailyDistribution': dailyCount,
      'hourlyDistribution': hourlyCount,
    };
  }

  Widget _buildOverviewSection(BuildContext context, List<CalendarEvent> events,
      Map<String, dynamic> insights) {
    final totalDuration =
        insights['totalDuration'] as Duration? ?? Duration.zero;
    final avgDuration =
        insights['averageDuration'] as Duration? ?? Duration.zero;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Overview',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Events',
                    events.length.toString(),
                    Icons.event,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Total Time',
                    _formatDuration(totalDuration),
                    Icons.schedule,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Avg Duration',
                    _formatDuration(avgDuration),
                    Icons.timer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAnalysisSection(
      BuildContext context, Map<String, dynamic> insights) {
    final dailyDist = insights['dailyDistribution'] as Map<String, int>? ?? {};
    final hourlyDist = insights['hourlyDistribution'] as Map<int, int>? ?? {};

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Time Patterns',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Peak hours - Visual timeline
            if (hourlyDist.isNotEmpty) ...[
              Text(
                'Daily Schedule Heatmap',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Container(
                height: 60,
                child: Row(
                  children: List.generate(24, (hour) {
                    final count = hourlyDist[hour] ?? 0;
                    final maxHourly = hourlyDist.values.isNotEmpty
                        ? hourlyDist.values.reduce((a, b) => a > b ? a : b)
                        : 1;
                    final intensity = count / maxHourly;

                    return Expanded(
                      child: GestureDetector(
                        onTap: count > 0
                            ? () => _showHourDetails(context, hour, count)
                            : null,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: count > 0
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.2 + (intensity * 0.6))
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (count > 0)
                                Text(
                                  count.toString(),
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                '${hour.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap any hour to see events • Darker = More Events',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 16),
            ],

            // Busiest days
            if (dailyDist.isNotEmpty) ...[
              Text(
                'Busiest Days',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...dailyDist.entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(e.key),
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: e.value /
                                (dailyDist.values.isNotEmpty
                                    ? dailyDist.values
                                        .reduce((a, b) => a > b ? a : b)
                                    : 1),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${e.value}'),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWordAnalysisSection(
      BuildContext context, Map<String, dynamic> insights) {
    final topWords = insights['topWords'] as List<MapEntry<String, int>>? ?? [];

    if (topWords.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxCount = topWords.isNotEmpty ? topWords.first.value : 1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cloud_rounded,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Topic Cloud',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Word heatmap/cloud with varying sizes
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topWords.take(20).map((entry) {
                final intensity = entry.value / maxCount;
                final fontSize = 12 + (intensity * 6); // 12-18px range
                final opacity =
                    0.4 + (intensity * 0.6); // 0.4-1.0 opacity range

                return GestureDetector(
                  onTap: () =>
                      _showWordDetails(context, entry.key, entry.value),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: opacity),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '${entry.key} (${entry.value})',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: intensity > 0.7
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),
            Text(
              'Tap any topic to see which events mention it',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWordDetails(BuildContext context, String word, int count) {
    // Find events that mention this word
    final provider = Provider.of<EventProvider>(context, listen: false);
    final mentioningEvents = provider.allEvents.where((event) {
      final text = '${event.title} ${event.description}'.toLowerCase();
      return text.contains(word.toLowerCase());
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Events mentioning "$word"'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Found in $count events:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              ...mentioningEvents.take(5).map((event) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.event,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.title,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
              if (mentioningEvents.length > 5)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '...and ${mentioningEvents.length - 5} more events',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHourDetails(BuildContext context, int hour, int count) {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final hourEvents = provider.allEvents.where((event) {
      return event.startTime.toLocal().hour == hour;
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            'Events at ${DateFormat('h a').format(DateTime(2025, 1, 1, hour))}'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$count events start at this hour:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              ...hourEvents.take(5).map((event) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                DateFormat('MMM d')
                                    .format(event.startTime.toLocal()),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              if (hourEvents.length > 5)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '...and ${hourEvents.length - 5} more events',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityAnalysisSection(
      BuildContext context, List<CalendarEvent> events) {
    final priorityCounts = <int, int>{};
    for (final event in events) {
      priorityCounts[event.priority] =
          (priorityCounts[event.priority] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.priority_high,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Priority Distribution',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    'High Priority',
                    (priorityCounts[1] ?? 0).toString(),
                    Icons.priority_high,
                    color: Theme.of(context).colorScheme.errorContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Medium Priority',
                    (priorityCounts[2] ?? 0).toString(),
                    Icons.remove,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard(
                    context,
                    'Low Priority',
                    (priorityCounts[3] ?? 0).toString(),
                    Icons.keyboard_arrow_down,
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon,
      {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  // Common words to filter out
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
    'make',
    'many',
    'over',
    'such',
    'take',
    'than',
    'them',
    'well',
    'were',
    'will',
    'your'
  };
}
