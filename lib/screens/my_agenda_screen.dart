import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../models/calendar_event.dart';
import '../widgets/event_card.dart';

class MyAgendaScreen extends StatelessWidget {
  const MyAgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        final selectedEvents = provider.getEventsByPriority();

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
          String dateKey = DateFormat('yyyy-MM-dd').format(event.startTime);
          if (!eventsByDate.containsKey(dateKey)) {
            eventsByDate[dateKey] = [];
          }
          eventsByDate[dateKey]!.add(event);
        }

        // Sort dates
        var sortedDates = eventsByDate.keys.toList()
          ..sort();

        return Column(
          children: [
            // Header with stats
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(context).colorScheme.surfaceVariant,
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
                    selectedEvents.where((e) => e.priority == 1).length.toString(),
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
                  dayEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          DateFormat('EEEE, MMMM d, yyyy').format(date),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      
                      // Events for this date
                      ...dayEvents.map((event) => EventCard(
                        event: event,
                        showDate: false, // Don't show date since we're grouping by date
                        onSelectionChanged: () {
                          provider.toggleEventSelection(event);
                        },
                        onPriorityChanged: (priority) {
                          provider.updateEventPriority(event, priority);
                        },
                      )).toList(),
                      
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

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
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
