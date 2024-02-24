import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void setDataTr(
    CollectionReference tr,
    String name,
    String selectedItem,
    DateTime selectedDateTime,
    String imagePath,
    String userId,
    int selectedIndex,
    ) {
  String dateString = makeDateInt(selectedDateTime);
  int dateInt = int.parse(dateString);
  tr.add({
    'name': name,
    'träning': selectedItem,
    'datum': DateFormat('yyyy-MM-dd').format(selectedDateTime),
    'tid': dateInt,
    'imagePath': imagePath,
    'userID': userId,
  }).catchError((error) => print('Add failed: $error'));
}

String makeDateInt(DateTime selectedDateTime) {
  return DateFormat('yyyyMMdd').format(selectedDateTime);
}
