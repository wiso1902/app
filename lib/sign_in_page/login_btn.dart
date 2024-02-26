import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_service.dart';

class login_btn extends StatelessWidget {
  const login_btn({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: () async {
          String? result = await context
              .read<AuthenticationService>()
              .signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          if (result == "SignedIn") {
            // Sign-in was successful, navigate to another page
            Navigator.pop(context, true);
          } else {
            // Sign-in failed, handle the error (e.g., display error message to the user)
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Sign-in Failed'),
                  content: Text(result ??
                      'Failed to sign in. Please check your credentials and try again.'),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Text(
          'Logga in',
          style: TextStyle(
              color: Colors.grey[300], fontSize: 22),
        ),
      ),
    );
  }
}