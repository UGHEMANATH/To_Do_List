# Smart Task Planner ✨

A beautiful, modern, and intuitive task management application built with Flutter. Stay organized, focus on what matters, and achieve your goals with an elegant and user-friendly interface.

## 🌟 Features

### ✨ Modern UI/UX
- **Beautiful Gradient Themes** - Eye-catching color gradients throughout the app
- **Smooth Animations** - Fluid transitions and micro-interactions
- **Card-Based Design** - Clean, organized layout with modern card components
- **Responsive Design** - Works seamlessly on all screen sizes

### 📋 Task Management
- **Create Tasks** - Add tasks with title, description, and details
- **Categories** - Organize tasks by Work, Personal, Shopping, Health, Study, and more
- **Priority Levels** - Set Low, Medium, or High priority for each task
- **Due Dates & Times** - Schedule tasks with date and time reminders
- **Progress Tracking** - Visual progress indicators showing completion status

### 🎨 User Experience
- **Engaging Onboarding** - Welcome new users with a beautiful 3-page onboarding flow
- **Animated Splash Screen** - Professional app launch experience
- **Statistics Dashboard** - Quick overview of completed and pending tasks
- **Quick Actions** - Easy access to Timeline, Focus Mode, and Statistics
- **Recent Tasks View** - See your latest tasks at a glance

### 🎯 Key Highlights
- Material 3 Design System
- Custom gradient backgrounds
- Emoji category icons
- Interactive task cards
- Real-time progress updates
- Motivational UI elements

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.10.7 or higher)
- Dart SDK
- iOS/Android emulator or physical device

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd smart_task_planner
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 📱 Screens

### Splash Screen
Beautiful animated logo with gradient background - creates a professional first impression.

### Onboarding Screens
- **Page 1**: Achieve Your Goals - Introduction to task management
- **Page 2**: Stay Organized - Learn about organization features
- **Page 3**: Track Progress - Understand progress tracking

### Home Screen
- Gradient header with welcome message
- Statistics cards showing completed and pending tasks
- Today's progress card with visual indicators
- Quick action buttons for Timeline, Focus Mode, and Statistics
- Recent tasks list with priority indicators

### Add Task Screen
- Beautiful form with gradient header
- Text inputs for title and description
- Category selection with emoji icons
- Priority level selector
- Date and time pickers
- Smooth animations and transitions

## 🎨 Color Palette

- **Primary**: #6366F1 (Indigo)
- **Secondary**: #8B5CF6 (Purple)
- **Accent**: #EC4899 (Pink)
- **Success**: #10B981 (Green)
- **Warning**: #F59E0B (Amber)
- **Danger**: #EF4444 (Red)

## 🏗️ Architecture

```
lib/
├── app/
│   ├── app.dart           # Main app widget
│   ├── app_theme.dart     # Theme configuration
│   └── routes.dart        # Navigation routes
├── models/
│   └── task_model.dart    # Task data model
├── providers/
│   └── task_provider.dart # State management
├── screens/
│   ├── splash/            # Splash screen
│   ├── onboarding/        # Onboarding flow
│   ├── home/              # Home dashboard
│   ├── add_task/          # Task creation
│   ├── timeline/          # Timeline view
│   ├── focus/             # Focus mode
│   └── settings/          # App settings
├── services/
│   └── local_storage_service.dart
├── utils/
│   ├── colors.dart        # Color constants
│   ├── constants.dart     # App constants
│   └── extensions.dart    # Utility extensions
└── widgets/
    ├── progress_card.dart  # Progress display
    ├── task_card.dart      # Task item widget
    ├── priority_chip.dart  # Priority indicator
    └── animated_fab.dart   # Floating action button
```

## 🔧 Technologies Used

- **Flutter** - UI framework
- **Dart** - Programming language
- **Material 3** - Design system
- **Provider** - State management (ready to implement)
- **Intl** - Internationalization and date formatting

## 📝 Task Model

```dart
enum Priority { low, medium, high }
enum TaskCategory { work, personal, shopping, health, study, other }

class TaskModel {
  String title;
  String description;
  Priority priority;
  TaskCategory category;
  DateTime? dueDate;
  DateTime? dueTime;
  bool isCompleted;
  DateTime createdAt;
}
```

## 🎯 Future Enhancements

- [ ] Task notifications and reminders
- [ ] Cloud sync functionality
- [ ] Dark mode support
- [ ] Task sharing features
- [ ] Advanced statistics and analytics
- [ ] Focus timer (Pomodoro technique)
- [ ] Calendar integration
- [ ] Voice input for tasks
- [ ] Subtasks and checklists
- [ ] Task tags and filters

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

Created with ❤️ using Flutter

---

**Note**: This is a modern redesign of a task planner app, featuring beautiful UI/UX improvements, smooth animations, and an engaging user experience perfect for new users entering the app.
