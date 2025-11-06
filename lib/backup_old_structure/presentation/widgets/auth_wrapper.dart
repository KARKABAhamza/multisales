import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/auth_screen.dart';
import '../screens/enhanced_dashboard_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If we have user data, user is logged in
        if (snapshot.hasData) {
          return const EnhancedDashboardScreen();
        }

        // Otherwise, show auth screen (sign-in/sign-up)
        return const AuthScreen();
      },
    );
  }
}
