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
                          DropdownMenuItem(value: 'all', child: Text('All Events')),
                          DropdownMenuItem(value: 'upcoming', child: Text('Upcoming Events')),
                          DropdownMenuItem(value: 'past', child: Text('Past Events')),
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
      final words = event.title.toLowerCase()
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
            : 0
      ),
      'topWords': topWords.take(10).toList(),
      'dailyDistribution': dailyCount,
      'hourlyDistribution': hourlyCount,
    };
  }

  Widget _buildOverviewSection(BuildContext context, List<CalendarEvent> events, Map<String, dynamic> insights) {
    final totalDuration = insights['totalDuration'] as Duration? ?? Duration.zero;
    final avgDuration = insights['averageDuration'] as Duration? ?? Duration.zero;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary),
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

  Widget _buildTimeAnalysisSection(BuildContext context, Map<String, dynamic> insights) {
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
                Icon(Icons.access_time, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Time Patterns',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Peak hours
            if (hourlyDist.isNotEmpty) ...[
              Text(
                'Peak Hours',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: hourlyDist.entries
                    .where((e) => e.value > 1)
                    .map((e) => Chip(
                          label: Text('${DateFormat('h a').format(DateTime(2025, 1, 1, e.key))} (${e.value})'),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        ))
                    .toList(),
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
              ...dailyDist.entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(e.key),
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: e.value / (dailyDist.values.isNotEmpty ? dailyDist.values.reduce((a, b) => a > b ? a : b) : 1),
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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

  Widget _buildWordAnalysisSection(BuildContext context, Map<String, dynamic> insights) {
    final topWords = insights['topWords'] as List<MapEntry<String, int>>? ?? [];
    
    if (topWords.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.text_fields, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Frequent Topics',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: topWords
                  .take(15)
                  .map((entry) => Chip(
                        label: Text('${entry.key} (${entry.value})'),
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityAnalysisSection(BuildContext context, List<CalendarEvent> events) {
    final priorityCounts = <int, int>{};
    for (final event in events) {
      priorityCounts[event.priority] = (priorityCounts[event.priority] ?? 0) + 1;
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.priority_high, color: Theme.of(context).colorScheme.primary),
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
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, {Color? color}) {
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
    'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'had', 'her', 'was', 'one', 'our',
    'out', 'day', 'get', 'has', 'him', 'his', 'how', 'its', 'may', 'new', 'now', 'old', 'see', 'two',
    'who', 'boy', 'did', 'she', 'use', 'way', 'what', 'with', 'have', 'from', 'they', 'know', 'want',
    'been', 'good', 'much', 'some', 'time', 'very', 'when', 'come', 'here', 'just', 'like', 'long',
    'make', 'many', 'over', 'such', 'take', 'than', 'them', 'well', 'were', 'will', 'your'
  };
}
