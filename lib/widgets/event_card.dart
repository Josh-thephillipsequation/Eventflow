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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: event.isSelected ? 2 : 1,
      color: event.isSelected 
          ? colorScheme.primaryContainer 
          : null,
      child: InkWell(
        onTap: onSelectionChanged,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: event.isSelected 
                            ? colorScheme.onPrimaryContainer
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
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('MMM d, yyyy').format(event.startTime),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${DateFormat('HH:mm').format(event.startTime)} - ${DateFormat('HH:mm').format(event.endTime)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.location,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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
                    Text(
                      'Priority:',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
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
                              style: theme.textTheme.labelSmall,
                            ),
                            selected: event.priority == priority,
                            onSelected: (bool selected) {
                              if (selected) {
                                onPriorityChanged(priority);
                              }
                            },
                            backgroundColor: _getPriorityColor(priority, false, colorScheme),
                            selectedColor: _getPriorityColor(priority, true, colorScheme),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getPriorityLabel(event.priority),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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

  Color _getPriorityColor(int priority, bool isSelected, ColorScheme colorScheme) {
    if (!isSelected) return colorScheme.surfaceContainerHighest;
    
    switch (priority) {
      case 1:
        return colorScheme.errorContainer;
      case 2:
        return Colors.orange.shade100;
      case 3:
        return Colors.yellow.shade100;
      case 4:
        return colorScheme.primaryContainer;
      case 5:
        return Colors.green.shade100;
      default:
        return colorScheme.surfaceContainerHighest;
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
