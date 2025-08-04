import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// LOGIN
  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (!_isValidEmail(email)) {
      _showSnackbar(context, "Please enter a valid email.");
      return;
    }

    if (password.isEmpty) {
      _showSnackbar(context, "Please enter your password.");
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _showSnackbar(context, "Login successful!");
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String error = _getErrorMessage(e);
      _showSnackbar(context, error);
    }
  }

  /// SIGN UP
  Future<void> signUp(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackbar(context, "All fields are required.");
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackbar(context, "Please enter a valid email.");
      return;
    }

    if (!_isStrongPassword(password)) {
      _showSnackbar(
        context,
        "Password must be at least 6 characters and include one special character.",
      );
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser?.reload();

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showSnackbar(context, "Account created successfully!");

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // Navigate back to login screen
      });
    } on FirebaseAuthException catch (e) {
      String error = _getErrorMessage(e);
      _showSnackbar(context, error);
    }
  }

  /// RESET PASSWORD
  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reset email sent!')));
      Navigator.pop(context); // Go back to login screen
    } on FirebaseAuthException catch (e) {
      String message = 'Enter email.';
      if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

/// VALIDATION HELPERS
bool _isValidEmail(String email) {
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  return emailRegex.hasMatch(email);
}

bool _isStrongPassword(String password) {
  // Minimum 6 characters + at least one special character
  return password.length >= 6 &&
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}

/// ERROR HANDLING
String _getErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      return "No account found with this email.";
    case 'wrong-password':
      return "Incorrect password.";
    case 'email-already-in-use':
      return "This email is already registered.";
    case 'invalid-email':
      return "Invalid email address.";
    case 'weak-password':
      return "Password should be at least 6 characters.";
    default:
      return "Something went wrong. Please try again.";
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.deepPurple,
      duration: const Duration(seconds: 3),
    ),
  );
}
