import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart';
import 'package:flutter/material.dart';


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
          if(passwordController.text.trim() == passwordControllerCheck.text.trim()) {
            context.read<AuthenticationService>().signUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );
          } else {
            AwesomeDialog(
              context: context,
              animType: AnimType.leftSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.error,
              showCloseIcon: true,
              title: 'Lösenorden stämmer inte',
              desc: "Lösenorden stämmer inte, kolla lösenorden och försök igen",
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
          'Skapa konto',
          style: TextStyle(
              color: Colors.grey[300], fontSize: 22),
        ),
      ),
    );
  }
}