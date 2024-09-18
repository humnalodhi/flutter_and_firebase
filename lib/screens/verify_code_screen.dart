import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_firebase/screens/home_screen.dart';
import 'package:flutter_and_firebase/utils/utils.dart';
import 'package:flutter_and_firebase/widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({
    super.key,
    required this.verificationId,
  });

  final String verificationId;

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final codeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: codeController,
            decoration: const InputDecoration(
              hintText: 'Enter 6 digit code',
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          RoundButton(
            loading: loading,
            title: 'Verify',
            onTap: () async {
              setState(() {
                loading = true;
              });
              final credentials = PhoneAuthProvider.credential(
                verificationId: widget.verificationId,
                smsCode: codeController.text.toString(),
              );

              try {
                await auth.signInWithCredential(credentials);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              } catch (e) {
                setState(() {
                  loading = false;
                });
                Utils().toastMessage(
                  e.toString(),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
