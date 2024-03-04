import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart';
import 'package:flutter/material.dart';

import '../create_user_page/create_user_page.dart';


class create_account_btn extends StatelessWidget {
  const create_account_btn({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.passwordControllerCheck
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordControllerCheck;
  final bool backButton= false;

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
          if (passwordController.text.trim() == passwordControllerCheck.text.trim()) {
            String? userId = await context.read<AuthenticationService>().signUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

            if (userId != null) {
              // Navigate to the new page and pass the user ID as an argument
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => create_user_page(userId: userId, enableBackButton: backButton,),
                ),
              );
            } else {
              AwesomeDialog(
                context: context,
                animType: AnimType.leftSlide,
                headerAnimationLoop: false,
                dialogType: DialogType.error,
                showCloseIcon: true,
                title: 'Error',
                desc: "An error occurd while registering check your internet connectivity and make sure your password was least 6 characters long",
                btnOkOnPress: () {
                  debugPrint('OnClcik');
                  passwordController.clear();
                  passwordControllerCheck.clear();
                },
                btnOkIcon: Icons.cancel,
                btnOkColor: Colors.red,
                onDismissCallback: (type) {
                  debugPrint('Dialog Dissmiss from callback $type');
                },
              ).show();
              // Handle sign-up failure
              // You can display an error message or perform any other action here
            }
          } else {
            AwesomeDialog(
              context: context,
              animType: AnimType.leftSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.error,
              showCloseIcon: true,
              title: 'Password doesnt match',
              desc: "The passwords doesnt match, check your passwords and try again",
              btnOkOnPress: () {
                debugPrint('OnClcik');
                passwordController.clear();
                passwordControllerCheck.clear();
              },
              btnOkIcon: Icons.cancel,
              btnOkColor: Colors.red,
              onDismissCallback: (type) {
                debugPrint('Dialog Dissmiss from callback $type');
              },
            ).show();
          }
        },
        child: Text(
          'Create account',
          style: TextStyle(
              color: Colors.grey[300], fontSize: 22),
        ),
      ),
    );
  }
}