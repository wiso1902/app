import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../widgets/palatte.dart';


late List<String> items = [];

Future<void> fetchItems() async {
  DocumentSnapshot ds = await FirebaseFirestore.instance.collection('val').doc('items').get();
  List<dynamic>? fetchedItems = ds.get('items');
  if (fetchedItems != null) {
    items = fetchedItems.cast<String>();
  }
}

void showCreateTr(BuildContext context, TextEditingController trController) {
  showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(
        "Lägg till en ny träning",
        style: kText,
      ),
      actions: [
        Column(
          children: [
            CupertinoTextField(
              controller: trController,
              style: kBodytext,
              textAlign: TextAlign.center,
              placeholder: "Ny träning",
              placeholderStyle: TextStyle(color: Colors.grey),
            ),
            TextButton(
              child: Text(
                "Lägg till",
                style: kText,
              ),
              onPressed: () {
                Addtr(context, trController);
              },
            ),
          ],
        ),
      ],
    ),
  );
}

void Addtr(BuildContext context, TextEditingController trController) async {
  await fetchItems();
  String newTraining = trController.text.trim();
  if (newTraining.isNotEmpty) {
    items.add(newTraining);
    var collection = FirebaseFirestore.instance.collection('val');
    collection
        .doc('items') // <-- Document ID
        .set({'items': items}) // <-- Update with the updated items list
        .then(
          (_) => AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: true,
        title: 'Ny träning tillagd',
        desc: "Nya träningen $newTraining är tillagd",
        btnOkOnPress: () {
          debugPrint('OnClcik');
          trController.clear();
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        },
      )..show(),
    ).catchError((error) => print('Add failed: $error'));
  }
}

