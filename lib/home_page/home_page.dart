import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('CupertinoButton Sample'),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CupertinoButton.filled(
              onPressed: () {context.read<AuthenticationService>().signOut();},
              child: const Text('Enabled'),
            ),
          ],
        ),
      ),
    );
  }
}
