import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_firebase/utils/utils.dart';
import 'package:flutter_and_firebase/widgets/round_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            RoundButton(
              title: 'Forgot',
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                auth
                    .sendPasswordResetEmail(email: emailController.text.toString(),)
                    .then((value) {
                  Utils().toastMessage(
                      'We have send you an email to recover password, please check email');
                  setState(() {
                    isLoading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(
                    error.toString(),
                  );
                  setState(() {
                    isLoading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
