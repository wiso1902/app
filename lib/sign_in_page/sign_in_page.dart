import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:why_appen/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:why_appen/widgets/palatte.dart';
import '../sign_up_page/sign_up_page.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[300],
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset('assets/images/why-logotyp-clean.webp',
                      width: 300, height: 150),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[500]?.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20),
                                    border: InputBorder.none,
                                    hintText: 'Email',
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    hintStyle: kBodytext,
                                  ),
                                  style: kBodytext,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  controller: emailController,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[500]?.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: TextField(
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20),
                                  border: InputBorder.none,
                                  hintText: 'Lösenord',
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Icon(
                                      FontAwesomeIcons.lock,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  hintStyle: kBodytext,
                                ),
                                style: kBodytext,
                                keyboardType: TextInputType.emailAddress,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                controller: passwordController,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
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
                                        password:
                                            passwordController.text.trim(),
                                      );

                                  if (result == "SignedIn") {
                                    // Sign-in was successful, navigate to another page
                                    Navigator.pop(context);
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
                                child: const Text('Logga in'),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: const Text("Saknar du konto?"))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
