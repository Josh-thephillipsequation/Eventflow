class CalendarEvent {
  final String uid;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  bool isSelected;
  int priority; // 1-5, 1 being highest priority

  CalendarEvent({
    required this.uid,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.isSelected = false,
    this.priority = 3,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'isSelected': isSelected,
      'priority': priority,
    };
  }

  static CalendarEvent fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
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
      isSelected: isSelected ?? this.isSelected,
      priority: priority ?? this.priority,
    );
  }
}
