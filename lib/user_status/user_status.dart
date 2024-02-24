import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../sign_in_page/sign_in_page.dart";



Future<Object?> checkSignInStatus(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // User is not signed in, navigate to the sign-in page
    // Return false if user is not signed in
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPage(),
      ),
    );
  } else {
    return true;
  }
}