import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart' as app_models;

class FirebaseAuthService {
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  bool _isInitialized = false;

  FirebaseAuthService() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await Firebase.app();
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      print('FirebaseAuthService: Firebase not initialized');
    }
  }

  // Get current user
  User? get currentUser {
    if (!_isInitialized || _auth == null) return null;
    return _auth!.currentUser;
  }

  // Stream of auth state changes
  Stream<User?> get authStateChanges {
    if (!_isInitialized || _auth == null) {
      return Stream.value(null);
    }
    return _auth!.authStateChanges();
  }

  // Sign up with email and password
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (!_isInitialized || _auth == null || _firestore == null) {
      return {'success': false, 'message': 'Firebase not configured'};
    }

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _auth!
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Create user document in Firestore
      await _firestore!.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });

      // Log the signup event
      await _logLoginHistory(userCredential.user!.uid, 'signup', email);

      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Account created successfully',
      };
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred. Please try again.',
      };
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized || _auth == null || _firestore == null) {
      return {'success': false, 'message': 'Firebase not configured'};
    }

    try {
      UserCredential userCredential = await _auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last login time
      await _firestore!
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({'lastLoginAt': FieldValue.serverTimestamp()});

      // Log the login event
      await _logLoginHistory(userCredential.user!.uid, 'login', email);

      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Login successful',
      };
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': _getErrorMessage(e.code)};
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred. Please try again.',
      };
    }
  }

  // Sign in with Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    if (!_isInitialized || _auth == null || _firestore == null) {
      return {'success': false, 'message': 'Firebase not configured'};
    }

    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return {'success': false, 'message': 'Google sign-in cancelled'};
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth!.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        return {'success': false, 'message': 'Google sign-in failed'};
      }

      final userDoc = await _firestore!.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore!.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? 'User',
          'email': user.email ?? '',
          'phone': user.phoneNumber ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore!.collection('users').doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }

      await _logLoginHistory(user.uid, 'google_login', user.email ?? '');

      return {
        'success': true,
        'user': user,
        'message': 'Google sign-in successful',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Google sign-in failed. Please try again.',
      };
    }
  }

  // Send OTP to phone number
  Future<Map<String, dynamic>> sendPhoneOtp({
    required String phoneNumber,
  }) async {
    if (!_isInitialized || _auth == null) {
      return {'success': false, 'message': 'Firebase not configured'};
    }

    final completer = Completer<Map<String, dynamic>>();

    await _auth!.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        if (!completer.isCompleted) {
          completer.complete({
            'success': true,
            'verificationId': '',
            'credential': credential,
          });
        }
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) {
          completer.complete({
            'success': false,
            'message': _getErrorMessage(e.code),
          });
        }
      },
      codeSent: (verificationId, resendToken) {
        if (!completer.isCompleted) {
          completer.complete({
            'success': true,
            'verificationId': verificationId,
            'resendToken': resendToken,
          });
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {
        if (!completer.isCompleted) {
          completer.complete({
            'success': true,
            'verificationId': verificationId,
          });
        }
      },
      timeout: const Duration(seconds: 60),
    );

    return completer.future;
  }

  // Verify OTP and sign in with phone
  Future<Map<String, dynamic>> verifyPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    if (!_isInitialized || _auth == null || _firestore == null) {
      return {'success': false, 'message': 'Firebase not configured'};
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth!.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        return {'success': false, 'message': 'OTP verification failed'};
      }

      final userDoc = await _firestore!.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _firestore!.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? 'User',
          'email': user.email ?? '',
          'phone': user.phoneNumber ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      } else {
        await _firestore!.collection('users').doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }

      await _logLoginHistory(user.uid, 'phone_login', user.email ?? '');

      return {
        'success': true,
        'user': user,
        'message': 'Phone login successful',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Invalid OTP. Please try again.',
      };
    }
  }

  // Link phone number to current user
  Future<Map<String, dynamic>> linkPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) async {
    if (!_isInitialized || _auth == null) {
      return {'success': false, 'message': 'Firebase not configured'};
    }

    final user = _auth!.currentUser;
    if (user == null) {
      return {'success': false, 'message': 'No active user'};
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await user.linkWithCredential(credential);
      return {'success': true, 'message': 'Phone verified'};
    } catch (e) {
      return {'success': false, 'message': 'Phone verification failed'};
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      if (_auth!.currentUser != null) {
        // Log the logout event
        await _logLoginHistory(
          _auth!.currentUser!.uid,
          'logout',
          _auth!.currentUser!.email ?? '',
        );
      }
      await _auth!.signOut();
    } catch (e) {
      throw Exception('Failed to sign out');
    }
  }

  // Get user data from Firestore
  Future<app_models.User?> getUserData(String uid) async {
    if (!_isInitialized || _firestore == null) return null;

    try {
      DocumentSnapshot doc = await _firestore!
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return app_models.User(
          id: data['uid'] ?? uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          phone: data['phone'] ?? '',
          password: '', // Don't store password in app
          createdAt:
              (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    required String uid,
    required String name,
    required String phone,
  }) async {
    try {
      await _firestore!.collection('users').doc(uid).update({
        'name': name,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update display name in auth
      await _auth!.currentUser?.updateDisplayName(name);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Log login history
  Future<void> _logLoginHistory(String uid, String action, String email) async {
    try {
      await _firestore!.collection('login_history').add({
        'uid': uid,
        'email': email,
        'action': action, // 'login', 'logout', 'signup'
        'timestamp': FieldValue.serverTimestamp(),
        'deviceInfo': {'platform': 'mobile', 'appVersion': '1.0.0'},
      });
    } catch (e) {
      // Log error but don't throw
      print('Failed to log login history: $e');
    }
  }

  // Get login history for a user
  Future<List<Map<String, dynamic>>> getLoginHistory(String uid) async {
    if (!_isInitialized || _firestore == null) return [];

    try {
      QuerySnapshot querySnapshot = await _firestore!
          .collection('login_history')
          .where('uid', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'action': data['action'],
          'email': data['email'],
          'timestamp': (data['timestamp'] as Timestamp?)?.toDate(),
          'deviceInfo': data['deviceInfo'],
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _auth!.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get error message
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      case 'user-disabled':
        return 'This user has been disabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
