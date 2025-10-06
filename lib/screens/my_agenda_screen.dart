import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../models/calendar_event.dart';
import '../widgets/event_card.dart';

class MyAgendaScreen extends StatefulWidget {
  const MyAgendaScreen({super.key});

  @override
  State<MyAgendaScreen> createState() => _MyAgendaScreenState();
}

class _MyAgendaScreenState extends State<MyAgendaScreen> {
  String _timeFilter = 'upcoming';

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        final allSelectedEvents = provider.getEventsByPriority();
        final now = DateTime.now();

        // Filter events by time
        final selectedEvents = allSelectedEvents.where((event) {
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

        if (selectedEvents.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No events selected',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Go to "All Events" to select events for your agenda',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Group events by date
        Map<String, List<CalendarEvent>> eventsByDate = {};
        for (var event in selectedEvents) {
          String dateKey =
              DateFormat('yyyy-MM-dd').format(event.startTime.toLocal());
          if (!eventsByDate.containsKey(dateKey)) {
            eventsByDate[dateKey] = [];
          }
          eventsByDate[dateKey]!.add(event);
        }

        // Sort dates
        var sortedDates = eventsByDate.keys.toList()..sort();

        return Column(
          children: [
            // Time filter selector
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('Show: '),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _timeFilter,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                            value: 'upcoming', child: Text('Upcoming Events')),
                        DropdownMenuItem(
                            value: 'all', child: Text('All My Events')),
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

            // Header with stats
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    context,
                    'Total Events',
                    selectedEvents.length.toString(),
                    Icons.event,
                  ),
                  _buildStatCard(
                    context,
                    'Days',
                    eventsByDate.length.toString(),
                    Icons.calendar_today,
                  ),
                  _buildStatCard(
                    context,
                    'High Priority',
                    selectedEvents
                        .where((e) => e.priority == 1)
                        .length
                        .toString(),
                    Icons.priority_high,
                  ),
                ],
              ),
            ),

            // Events grouped by date
            Expanded(
              child: ListView.builder(
                itemCount: sortedDates.length,
                itemBuilder: (context, dateIndex) {
                  String dateKey = sortedDates[dateIndex];
                  DateTime date = DateTime.parse(dateKey);
                  List<CalendarEvent> dayEvents = eventsByDate[dateKey]!;

                  // Sort events within the day by start time
                  dayEvents.sort((a, b) =>
                      a.startTime.toLocal().compareTo(b.startTime.toLocal()));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        margin: const EdgeInsets.only(top: 8.0),
                        decoration: BoxDecoration(
                          color: _isToday(date)
                              ? Theme.of(context).colorScheme.primaryContainer
                              : _isPast(date)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .surfaceContainerHighest
                                  : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isToday(date)
                                  ? Icons.today
                                  : _isPast(date)
                                      ? Icons.history
                                      : Icons.upcoming,
                              color: _isToday(date)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                  : _isPast(date)
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSecondaryContainer,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getDayLabel(date),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _isToday(date)
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer
                                      : _isPast(date)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer,
                                ),
                              ),
                            ),
                            Text(
                              '${dayEvents.length} event${dayEvents.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _isToday(date)
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                        .withValues(alpha: 0.7)
                                    : _isPast(date)
                                        ? Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.7)
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer
                                            .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Events for this date
                      ...dayEvents.map((event) => EventCard(
                            event: event,
                            showDate:
                                false, // Don't show date since we're grouping by date
                            onSelectionChanged: () {
                              provider.toggleEventSelection(event);
                            },
                            onPriorityChanged: (priority) {
                              provider.updateEventPriority(event, priority);
                            },
                          )),

                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);
    return compareDate.isAtSameMomentAs(today);
  }

  bool _isPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);
    return compareDate.isBefore(today);
  }

  String _getDayLabel(DateTime date) {
    final dayLabel = DateFormat('EEEE, MMMM d, yyyy').format(date);
    if (_isToday(date)) {
      return 'Today - $dayLabel';
    } else if (_isPast(date)) {
      return 'Past - $dayLabel';
    }
    return dayLabel;
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
