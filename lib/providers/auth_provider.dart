import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  String? _errorMessage;
  bool _firebaseAvailable = true;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String? get errorMessage => _errorMessage;

  // Initialize - check if user is already logged in
  Future<void> initialize() async {
    try {
      // Check if Firebase is initialized
      await Firebase.app();
      _firebaseAvailable = true;

      final firebaseUser = _firebaseAuthService.currentUser;
      if (firebaseUser != null) {
        _currentUser = await _firebaseAuthService.getUserData(firebaseUser.uid);
        _isLoggedIn = _currentUser != null;
        notifyListeners();
      }
    } catch (e) {
      _firebaseAvailable = false;
      print('Firebase not available: $e');
    }
  }

  // Sign Up with Firebase
  Future<bool> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (!_firebaseAvailable) {
      _errorMessage =
          'Firebase not configured. Please set up Firebase to enable cloud authentication.';
      notifyListeners();
      return false;
    }

    try {
      _errorMessage = null;

      final result = await _firebaseAuthService.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (result['success'] == true) {
        final firebaseUser = result['user'] as firebase_auth.User;
        _currentUser = await _firebaseAuthService.getUserData(firebaseUser.uid);
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during signup';
      notifyListeners();
      return false;
    }
  }

  // Login with email or phone and password
  Future<bool> login({
    required String identifier, // Can be email or phone
    required String password,
  }) async {
    if (!_firebaseAvailable) {
      _errorMessage =
          'Firebase not configured. Please set up Firebase to enable cloud authentication.';
      notifyListeners();
      return false;
    }

    try {
      _errorMessage = null;

      final result = await _firebaseAuthService.signIn(
        identifier: identifier,
        password: password,
      );

      if (result['success'] == true) {
        final firebaseUser = result['user'] as firebase_auth.User;
        _currentUser = await _firebaseAuthService.getUserData(firebaseUser.uid);
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during login';
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _firebaseAuthService.signOut();
      _currentUser = null;
      _isLoggedIn = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to logout';
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String name,
    required String phone,
  }) async {
    try {
      if (_currentUser == null) return false;

      final success = await _firebaseAuthService.updateUserProfile(
        uid: _currentUser!.id,
        name: name,
        phone: phone,
      );

      if (success) {
        _currentUser = _currentUser!.copyWith(name: name, phone: phone);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update profile';
      notifyListeners();
      return false;
    }
  }

  // Get login history
  Future<List<Map<String, dynamic>>> getLoginHistory() async {
    if (_currentUser == null) return [];
    return await _firebaseAuthService.getLoginHistory(_currentUser!.id);
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      return await _firebaseAuthService.resetPassword(email);
    } catch (e) {
      _errorMessage = 'Failed to send reset email';
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
