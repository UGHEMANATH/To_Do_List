import 'package:flutter/foundation.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  List<TaskModel> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<TaskModel> get pendingTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  int get totalTasks => _tasks.length;

  int get completedCount => completedTasks.length;

  int get pendingCount => pendingTasks.length;

  double get completionPercentage => totalTasks == 0
      ? 0.0
      : (completedCount / totalTasks * 100).roundToDouble() / 100;

  void addTask(TaskModel task) {
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  void toggleTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }

  void updateTask(int index, TaskModel task) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void addSampleTasks() {
    _tasks.addAll([
      TaskModel(
        title: 'Complete project proposal',
        description: 'Finish the Q1 project proposal',
        priority: Priority.high,
        category: TaskCategory.work,
        dueTime: const TimeOfDayModel(hour: 14, minute: 0),
        isCompleted: false,
      ),
      TaskModel(
        title: 'Review design mockups',
        description: 'Check the new UI designs',
        priority: Priority.medium,
        category: TaskCategory.work,
        dueTime: const TimeOfDayModel(hour: 16, minute: 30),
        isCompleted: false,
      ),
      TaskModel(
        title: 'Team meeting preparation',
        description: 'Prepare slides for team sync',
        priority: Priority.medium,
        category: TaskCategory.work,
        dueTime: const TimeOfDayModel(hour: 17, minute: 0),
        isCompleted: false,
      ),
      TaskModel(
        title: 'Buy groceries',
        description: 'Milk, eggs, vegetables',
        priority: Priority.low,
        category: TaskCategory.shopping,
        isCompleted: false,
      ),
      TaskModel(
        title: 'Morning exercise',
        description: '30 minutes workout',
        priority: Priority.medium,
        category: TaskCategory.health,
        isCompleted: true,
      ),
      TaskModel(
        title: 'Read documentation',
        description: 'Flutter state management guide',
        priority: Priority.low,
        category: TaskCategory.study,
        isCompleted: true,
      ),
      TaskModel(
        title: 'Client meeting',
        description: 'Discuss project timeline',
        priority: Priority.high,
        category: TaskCategory.work,
        isCompleted: true,
      ),
    ]);
    notifyListeners();
  }
}
