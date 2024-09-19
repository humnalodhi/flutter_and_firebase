import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_firebase/screens/firebase_auth/login_screen.dart';
import 'package:flutter_and_firebase/screens/firestore_db_list_manipulation/list_screen.dart';
import 'package:flutter_and_firebase/screens/realtime_db_list_manipulations/home_screen.dart';
import 'package:flutter_and_firebase/screens/firebase_storage/upload_image_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        },
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
      );
    }
  }
}
