import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/signup/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/add_task/add_task_screen.dart';
import '../screens/focus/focus_screen.dart';
import '../screens/timeline/timeline_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const addTask = '/add-task';
  static const focus = '/focus';
  static const timeline = '/timeline';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    signup: (_) => const SignupScreen(),
    onboarding: (_) => const OnboardingScreen(),
    home: (_) => const HomeScreen(),
    addTask: (_) => const AddTaskScreen(),
    focus: (_) => const FocusScreen(),
    timeline: (_) => const TimelineScreen(),
    settings: (_) => const SettingsScreen(),
  };
}
