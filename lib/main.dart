import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Firebase initialization error: $e');
    print(
      'Running app without Firebase - Please configure Firebase to enable cloud features',
    );
  }

  runApp(const SmartTaskPlannerApp());
}
