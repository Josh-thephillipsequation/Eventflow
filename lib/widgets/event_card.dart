import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/calendar_event.dart';

class EventCard extends StatelessWidget {
  final CalendarEvent event;
  final bool showDate;
  final VoidCallback onSelectionChanged;
  final Function(int) onPriorityChanged;

  const EventCard({
    super.key,
    required this.event,
    this.showDate = true,
    required this.onSelectionChanged,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: event.isSelected ? 4 : 1,
      color: event.isSelected 
          ? Theme.of(context).colorScheme.primaryContainer 
          : null,
      child: InkWell(
        onTap: onSelectionChanged,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: event.isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : null,
                      ),
                    ),
                  ),
                  Checkbox(
                    value: event.isSelected,
                    onChanged: (bool? value) {
                      onSelectionChanged();
                    },
                  ),
                ],
              ),
              
              if (showDate) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(event.startTime),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              if (event.location.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              
              if (event.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              if (event.isSelected) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Priority:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: List.generate(5, (index) {
                          int priority = index + 1;
                          return ChoiceChip(
                            label: Text(
                              priority.toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            selected: event.priority == priority,
                            onSelected: (bool selected) {
                              if (selected) {
                                onPriorityChanged(priority);
                              }
                            },
                            backgroundColor: _getPriorityColor(priority, false),
                            selectedColor: _getPriorityColor(priority, true),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getPriorityLabel(event.priority),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority, bool isSelected) {
    if (!isSelected) return Colors.grey.shade200;
    
    switch (priority) {
      case 1:
        return Colors.red.shade100;
      case 2:
        return Colors.orange.shade100;
      case 3:
        return Colors.yellow.shade100;
      case 4:
        return Colors.blue.shade100;
      case 5:
        return Colors.green.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'Must attend';
      case 2:
        return 'High priority';
      case 3:
        return 'Medium priority';
      case 4:
        return 'Low priority';
      case 5:
        return 'Optional';
      default:
        return 'Medium priority';
    }
  }
}
