import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/event_provider.dart';
import '../models/calendar_event.dart';
import '../widgets/event_card.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  String _searchQuery = '';
  String _sortBy = 'time'; // 'time', 'title', 'priority'
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _itemKeys = {};
  bool _hasScrolled = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, provider, child) {
        if (provider.allEvents.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No events loaded',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Go to the Import tab to load a calendar',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        List<CalendarEvent> filteredEvents = _getFilteredAndSortedEvents(provider.allEvents);

        // Populate item keys for scrolling
        for (final e in filteredEvents) {
          _itemKeys.putIfAbsent(e.uid, () => GlobalKey());
        }

        // After first frame, scroll to the first event near now (once)
        if (!_hasScrolled) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToCurrentEvent(filteredEvents);
            _hasScrolled = true;
          });
        }

        return Column(
          children: [
            // Search and Filter Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search events...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                        _hasScrolled = false;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Sort by: '),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<String>(
                          value: _sortBy,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'time', child: Text('Start Time')),
                            DropdownMenuItem(value: 'day', child: Text('Day')),
                            DropdownMenuItem(value: 'title', child: Text('Title')),
                            DropdownMenuItem(value: 'priority', child: Text('Priority')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _sortBy = value;
                                _hasScrolled = false;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Events List
            Expanded(
              child: _sortBy == 'day'
                  ? _buildGroupedListView(filteredEvents, provider)
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
                        return KeyedSubtree(
                          key: _itemKeys[event.uid],
                          child: EventCard(
                            event: event,
                            onSelectionChanged: () {
                              provider.toggleEventSelection(event);
                            },
                            onPriorityChanged: (priority) {
                              provider.updateEventPriority(event, priority);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupedListView(List<CalendarEvent> events, EventProvider provider) {
    // Group events by date (local date)
    final Map<String, List<CalendarEvent>> groups = {};
    for (final e in events) {
      final key = DateFormat('yyyy-MM-dd').format(e.startTime.toLocal());
      groups.putIfAbsent(key, () => []).add(e);
    }

    final sortedKeys = groups.keys.toList()..sort();

    return ListView.builder(
      controller: _scrollController,
      itemCount: sortedKeys.length,
      itemBuilder: (context, sectionIndex) {
        final dayKey = sortedKeys[sectionIndex];
        final dayEvents = groups[dayKey]!..sort((a, b) => a.startTime.compareTo(b.startTime));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                DateFormat.yMMMMEEEEd().format(DateTime.parse(dayKey)),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...dayEvents.map((event) => KeyedSubtree(
                  key: _itemKeys[event.uid],
                  child: EventCard(
                    event: event,
                    onSelectionChanged: () {
                      provider.toggleEventSelection(event);
                    },
                    onPriorityChanged: (priority) {
                      provider.updateEventPriority(event, priority);
                    },
                  ),
                ))
          ],
        );
      },
    );
  }

  void _scrollToCurrentEvent(List<CalendarEvent> events) {
    if (events.isEmpty) return;

    final now = DateTime.now();
    // Find first event that starts at or after now minus 1 hour
    final threshold = now.subtract(const Duration(hours: 1));
    CalendarEvent? target;
    for (final e in events) {
      if (e.startTime.isAfter(threshold) || e.startTime.isAtSameMomentAs(threshold)) {
        target = e;
        break;
      }
    }

    // If none found, pick the last event (or first)
    target ??= events.first;

    final key = _itemKeys[target.uid];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 350),
        alignment: 0.1,
      );
    }
  }

  List<CalendarEvent> _getFilteredAndSortedEvents(List<CalendarEvent> events) {
    // Filter by search query
    List<CalendarEvent> filtered = events.where((event) {
      if (_searchQuery.isEmpty) return true;
      return event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             event.location.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Sort events
    switch (_sortBy) {
      case 'title':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'priority':
        filtered.sort((a, b) => a.priority.compareTo(b.priority));
        break;
      case 'day':
        // Sort by date then time
        filtered.sort((a, b) {
          final ad = DateTime(a.startTime.year, a.startTime.month, a.startTime.day);
          final bd = DateTime(b.startTime.year, b.startTime.month, b.startTime.day);
          final cmp = ad.compareTo(bd);
          if (cmp != 0) return cmp;
          return a.startTime.compareTo(b.startTime);
        });
        break;
      case 'time':
      default:
        filtered.sort((a, b) => a.startTime.compareTo(b.startTime));
        break;
    }

    return filtered;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
