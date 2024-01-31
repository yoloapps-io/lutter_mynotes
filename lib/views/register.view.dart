import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final passowrd = _password.text;
                      print(email);
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: passowrd);
                      } on FirebaseAuthException catch (error) {
                        if (error.code == 'weak-password') {
                          print('weak password');
                        } else if (error.code == 'email-already-in-use') {
                          print('email in used login or use another email');
                        } else if (error.code == 'invalid-email') {
                          print('invalid email entered');
                        }
                      }
                    },
                    child: const Text('Register'),
                  ),
                ],
              );
            default:
              return const Text('Loading');
          }
        },
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
      ),
    );
  }
}
