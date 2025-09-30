class CalendarEvent {
  final String uid;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String speaker;
  bool isSelected;
  int priority; // 1-5, 1 being highest priority

  CalendarEvent({
    required this.uid,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.speaker = '',
    this.isSelected = false,
    this.priority = 3,
  });

  Map<String, dynamic> toJson() {
    // DELIBERATE TEST FAILURE: Missing closing brace to test auto-feedback
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'speaker': speaker,
      'isSelected': isSelected,
      'priority': priority,
    ;  // <-- SYNTAX ERROR: Missing closing brace
  }

  static CalendarEvent fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      speaker: json['speaker'] ?? '',
      isSelected: json['isSelected'] ?? false,
      priority: json['priority'] ?? 3,
    );
  }

  CalendarEvent copyWith({
    String? uid,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? speaker,
    bool? isSelected,
    int? priority,
  }) {
    return CalendarEvent(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      speaker: speaker ?? this.speaker,
      isSelected: isSelected ?? this.isSelected,
      priority: priority ?? this.priority,
    );
  }
}
