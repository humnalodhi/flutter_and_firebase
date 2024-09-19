import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_and_firebase/screens/firebase_auth/forgot_password_screen.dart';
import 'package:flutter_and_firebase/screens/firebase_auth/signup_screen.dart';
import 'package:flutter_and_firebase/screens/realtime_db_list_manipulations/home_screen.dart';
import 'package:flutter_and_firebase/utils/utils.dart';
import 'package:flutter_and_firebase/widgets/round_button.dart';

import 'login_with_phone_num_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool loading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  void login() {
    setState(() {
      loading = true;
    });
    auth
        .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
        .then((value) {
      Utils().toastMessage(
        value.user!.email.toString(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utils().toastMessage(
        error.toString(),
      );
      setState(() {
        loading = false;
      });
    });
    emailController.clear();
    passwordController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          leading: const SizedBox(),
          centerTitle: true,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.password_outlined,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginWithPhoneNumScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Login with Phone Number',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
