import 'package:flutter/material.dart';

import '../sign_up_page/sign_up_page.dart';

class skapa_konto_btn extends StatelessWidget {
  const skapa_konto_btn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Gå tillbaka",
              style: TextStyle(color: Colors.grey[700])),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUpPage()),
            );
          },
          child: Text("Skapa konto",
              style: TextStyle(color: Colors.grey[700])),
        ),
      ],
    );
  }
}