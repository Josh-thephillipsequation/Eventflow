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
  String _sortBy = 'day'; // Default to 'day' for better UX
  String _timeFilter = 'upcoming'; // 'all', 'upcoming', 'past'
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
                      Expanded(
                        child: Row(
                          children: [
                            const Text('Filter: '),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButton<String>(
                                value: _timeFilter,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
                                  DropdownMenuItem(value: 'all', child: Text('All Events')),
                                  DropdownMenuItem(value: 'past', child: Text('Past Events')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _timeFilter = value;
                                      _hasScrolled = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Row(
                          children: [
                            const Text('Sort: '),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButton<String>(
                                value: _sortBy,
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(value: 'day', child: Text('By Day')),
                                  DropdownMenuItem(value: 'time', child: Text('By Time')),
                                  DropdownMenuItem(value: 'title', child: Text('By Title')),
                                  DropdownMenuItem(value: 'priority', child: Text('By Priority')),
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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
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
        final dayDate = DateTime.parse(dayKey);
        final dayEvents = groups[dayKey]!..sort((a, b) => a.startTime.toLocal().compareTo(b.startTime.toLocal()));
        
        // Determine if this is today, past, or future
        final isPast = dayDate.isBefore(today);
        final isToday = dayDate.isAtSameMomentAs(today);
        
        // Create the day label with context
        String dayLabel = DateFormat.yMMMMEEEEd().format(dayDate);
        if (isToday) {
          dayLabel = 'Today - $dayLabel';
        } else if (isPast) {
          dayLabel = 'Past - $dayLabel';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              margin: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                color: isToday 
                    ? Theme.of(context).colorScheme.primaryContainer
                    : isPast 
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isToday 
                        ? Icons.today 
                        : isPast 
                            ? Icons.history 
                            : Icons.upcoming,
                    color: isToday 
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : isPast 
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSecondaryContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dayLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isToday 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : isPast 
                                ? Theme.of(context).colorScheme.onSurface
                                : Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                  Text(
                    '${dayEvents.length} event${dayEvents.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isToday 
                          ? Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7)
                          : isPast 
                              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
                              : Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                    ),
                  ),
                ],
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
                )),
            const SizedBox(height: 4),
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
      if (e.startTime.toLocal().isAfter(threshold) || e.startTime.toLocal().isAtSameMomentAs(threshold)) {
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
    final now = DateTime.now();
    
    // Filter by search query and time filter
    List<CalendarEvent> filtered = events.where((event) {
      // Search query filter
      bool matchesSearch = _searchQuery.isEmpty ||
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.location.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Time filter
      bool matchesTime = true;
      switch (_timeFilter) {
        case 'upcoming':
          // Show events that end after now (current or future events)
          matchesTime = event.endTime.toLocal().isAfter(now);
          break;
        case 'past':
          // Show events that ended before now
          matchesTime = event.endTime.toLocal().isBefore(now);
          break;
        case 'all':
        default:
          matchesTime = true;
          break;
      }
      
      return matchesSearch && matchesTime;
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
          final aLocal = a.startTime.toLocal();
          final bLocal = b.startTime.toLocal();
          final ad = DateTime(aLocal.year, aLocal.month, aLocal.day);
          final bd = DateTime(bLocal.year, bLocal.month, bLocal.day);
          final cmp = ad.compareTo(bd);
          if (cmp != 0) return cmp;
          return aLocal.compareTo(bLocal);
        });
        break;
      case 'time':
      default:
        filtered.sort((a, b) => a.startTime.toLocal().compareTo(b.startTime.toLocal()));
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
