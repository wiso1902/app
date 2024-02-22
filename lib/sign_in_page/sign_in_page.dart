import 'package:flutter/material.dart';
import 'package:why_appen/sign_in_page/skapa_konto_btn.dart';
import '../sign_up_page/sign_up_page.dart';
import 'login_btn.dart';
import 'password_field.dart';
import 'text_field.dart';

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
                            email_text(emailController: emailController),
                            password_field(passwordController: passwordController),
                          ],
                        ),
                        Column(
                          children: [
                            login_btn(emailController: emailController, passwordController: passwordController),
                          ],
                        ),
                        skapa_konto_btn()
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




