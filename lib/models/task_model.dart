import 'package:flutter/material.dart';

enum Priority { low, medium, high }

enum TaskCategory { work, personal, shopping, health, study, other }

class TimeOfDayModel {
  final int hour;
  final int minute;

  const TimeOfDayModel({required this.hour, required this.minute});

  @override
  String toString() {
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }

  String format(BuildContext? context) {
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$displayHour:$displayMinute $period';
  }
}

class TaskModel {
  String title;
  String description;
  Priority priority;
  TaskCategory category;
  DateTime? dueDate;
  TimeOfDayModel? dueTime;
  bool isCompleted;
  DateTime createdAt;

  TaskModel({
    required this.title,
    this.description = '',
    this.priority = Priority.low,
    this.category = TaskCategory.other,
    this.dueDate,
    this.dueTime,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String getCategoryIcon() {
    switch (category) {
      case TaskCategory.work:
        return '💼';
      case TaskCategory.personal:
        return '👤';
      case TaskCategory.shopping:
        return '🛒';
      case TaskCategory.health:
        return '❤️';
      case TaskCategory.study:
        return '📚';
      case TaskCategory.other:
        return '📌';
    }
  }

  String getCategoryName() {
    return category.name[0].toUpperCase() + category.name.substring(1);
  }
}
