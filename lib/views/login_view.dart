import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
      appBar: AppBar(title: const Text('Login')),
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
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email, password: passowrd);
                        print(userCredential);
                      } on FirebaseAuthException catch (error) {
                        print(error.code);
                        if (error.code == 'invalid-email') {
                          print('Error: entered invalid email');
                        } else if (error.code == 'user-not-found') {
                          print(
                              'Error: wrong email or password, user not found');
                        } else if (error.code == 'wrong-password') {
                          print('Error: wrong password');
                        }
                      } catch (error) {
                        print('An unexpected error occurred: $error');
                      }
                    },
                    child: const Text('Login'),
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
