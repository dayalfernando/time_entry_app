class Task {
  final int? id;
  final String clientName;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final int breakDuration; // in minutes
  final int travelTime; // in minutes
  final String comments;
  final bool isCompleted;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;

  Task({
    this.id,
    required this.clientName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.breakDuration,
    required this.travelTime,
    required this.comments,
    this.isCompleted = false,
    this.actualStartTime,
    this.actualEndTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'date': date.toIso8601String(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'breakDuration': breakDuration,
      'travelTime': travelTime,
      'comments': comments,
      'isCompleted': isCompleted ? 1 : 0,
      'actualStartTime': actualStartTime?.toIso8601String(),
      'actualEndTime': actualEndTime?.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      clientName: map['clientName'] as String,
      date: DateTime.parse(map['date'] as String),
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      breakDuration: map['breakDuration'] as int,
      travelTime: map['travelTime'] as int,
      comments: map['comments'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
      actualStartTime: map['actualStartTime'] != null ? DateTime.parse(map['actualStartTime'] as String) : null,
      actualEndTime: map['actualEndTime'] != null ? DateTime.parse(map['actualEndTime'] as String) : null,
    );
  }

  Task copyWith({
    int? id,
    String? clientName,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    int? breakDuration,
    int? travelTime,
    String? comments,
    bool? isCompleted,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
  }) {
    return Task(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      breakDuration: breakDuration ?? this.breakDuration,
      travelTime: travelTime ?? this.travelTime,
      comments: comments ?? this.comments,
      isCompleted: isCompleted ?? this.isCompleted,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
    );
  }
}