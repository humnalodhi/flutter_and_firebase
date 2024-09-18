import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_firebase/screens/firebase_auth/verify_code_screen.dart';
import 'package:flutter_and_firebase/utils/utils.dart';
import 'package:flutter_and_firebase/widgets/round_button.dart';

class LoginWithPhoneNumScreen extends StatefulWidget {
  const LoginWithPhoneNumScreen({super.key});

  @override
  State<LoginWithPhoneNumScreen> createState() =>
      _LoginWithPhoneNumScreenState();
}

class _LoginWithPhoneNumScreenState extends State<LoginWithPhoneNumScreen> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Phone Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneNumberController,
              decoration: const InputDecoration(hintText: '+1 234 5678 993'),
            ),
            const SizedBox(
              height: 50,
            ),
            RoundButton(
              loading: loading,
              title: 'Login',
              onTap: () {
                setState(() {
                  loading = true;
                });
                auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_) {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e) {
                    Utils().toastMessage(
                      e.toString(),
                    );
                    setState(() {
                      loading = false;
                    });
                    print(e.toString());
                  },
                  codeSent: (String verificationId, int? token) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyCodeScreen(
                          verificationId: verificationId,
                        ),
                      ),
                    );
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (e) {
                    Utils().toastMessage(
                      e.toString(),
                    );
                    setState(
                      () {
                        loading = false;
                      },
                    );
                    print(e.toString());
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
