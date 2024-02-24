import 'package:flutter/cupertino.dart';

Widget buildDatePicker(DateTime selectedDateTime, Function(DateTime) onDateTimeChanged) => SizedBox(
  height: 350,
  child: CupertinoDatePicker(
    minimumYear: DateTime.now().year,
    maximumYear: DateTime.now().year,
    maximumDate: DateTime.now(),
    initialDateTime: selectedDateTime,
    mode: CupertinoDatePickerMode.date,
    onDateTimeChanged: onDateTimeChanged,
  ),
);
