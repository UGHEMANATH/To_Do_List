import 'package:flutter/material.dart';
import '../models/task_model.dart';

class PriorityChip extends StatelessWidget {
  final Priority priority;

  const PriorityChip({super.key, required this.priority});

  Color getColor() {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  String getText() {
    return priority.name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(getText(), style: const TextStyle(color: Colors.white)),
      backgroundColor: getColor(),
    );
  }
}
