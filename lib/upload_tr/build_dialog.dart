import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart';
import 'date_picker.dart';
import '../main.dart';
import 'tr_picker.dart';

import '../widgets/palatte.dart'; // Import any necessary dependencies

void showAlertDialog(
    BuildContext context,
    List<String> items,
    int index,
    DateTime dateTime,
    List<DateTime> selectedDates,
    TextEditingController trController,
    Function getTotal,
    Function addDateToList,
    Function setDataTr,
    Function setDataTop,
    CollectionReference tr, // Pass CollectionReference tr
    String name, // Pass String name
    String imagePath, // Pass String imagePath
    String userId, // Pass String userId
    int selectedIndex, // Pass int selectedIndex
    DateTime selectedDateTime, // Pass DateTime selectedDateTime
    ) {
  var scrollController = FixedExtentScrollController(initialItem: index);
  String getText() {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
      builder: (context, setState) {
        return CupertinoAlertDialog(
          title: Text("Lägg till träning", style: kText),
          actions: [
            CupertinoButton(
              child: Text(items[index],
                  style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                scrollController.dispose();
                scrollController =
                    FixedExtentScrollController(initialItem: index);
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      buildPickerTr(
                        scrollController,
                        items,
                        index,
                            (selectedIndex) {
                          setState(() {
                            index = selectedIndex;
                          });
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => items[index]);
                      },
                    ),
                  ),
                );
              },
            ),
            CupertinoButton(
              child: Text(getText(),
                  style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      buildDatePicker(
                        dateTime,
                            (selectedDateTime) {
                          setState(() {
                            dateTime = selectedDateTime;
                          });
                        },
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          dateTime = dateTime;
                          getText();
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                if (!selectedDates.contains(dateTime)) {
                  setState(() {
                    Navigator.pop(context, 'OK');
                    getTotal();
                    addDateToList(dateTime);
                    setDataTr(
                      tr,
                      name,
                      items[index],
                      dateTime,
                      imagePath,
                      userId,
                      selectedIndex,
                    );
                    setDataTop();
                  });
                } else {
                  print(dateTime);
                  String makeDateshow() {
                    return DateFormat('yyyy-MM-dd').format(dateTime);
                  }

                  String dateShow = makeDateshow();
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.leftSlide,
                    headerAnimationLoop: false,
                    dialogType: DialogType.error,
                    showCloseIcon: true,
                    title: 'Datum redan sparat',
                    desc:
                    "Du har redan sparat en träning med datumet $dateShow testa ett nytt datum",
                    btnOkOnPress: () {
                      debugPrint('OnClcik');
                    },
                    btnOkIcon: Icons.cancel,
                    btnOkColor: Colors.red,
                    onDismissCallback: (type) {
                      debugPrint('Dialog Dissmiss from callback $type');
                    },
                  ).show();
                }
              },
              child: Text('OK', style: kText),
            ),
          ],
        );
      },
    ),
  );
}

