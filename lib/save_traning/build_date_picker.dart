import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime)? onDateSelected;

  const CustomDatePicker({Key? key, this.onDateSelected}) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late SharedPreferences _prefs;
  late DateTime selectedDate = DateTime.now(); // Declare selectedDate without "?" to ensure it's initialized

  @override
  void initState() {
    super.initState();
    _loadSelectedDate();
  }

  Future<void> _saveSelectedDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedDate', date.millisecondsSinceEpoch);
  }

  Future<void> _loadSelectedDate() async {
    _prefs = await SharedPreferences.getInstance();
    final savedDateMilliseconds = _prefs.getInt('selectedDate');
    if (savedDateMilliseconds != null) {
      setState(() {
        selectedDate =
            DateTime.fromMillisecondsSinceEpoch(savedDateMilliseconds);
      });
    } else {
      selectedDate = DateTime.now(); // Just initialize the variable
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _showDatePicker(context);
            },
            child: Text('Select Date'),
          ),
          if (selectedDate != null)
            Text(
              DateFormat('yyyy-MM-dd').format(selectedDate),
              style: TextStyle(fontSize: 20),
            ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime currentDate = DateTime.now();

    final DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: CupertinoDatePicker(
            maximumYear: DateTime.now().year,
            minimumYear: DateTime.now().year,
            mode: CupertinoDatePickerMode.date,
            // Set mode to dateAndMonth
            initialDateTime: selectedDate,
            minimumDate: DateTime(1900),
            // Adjust the minimum date as needed
            maximumDate: currentDate,
            // Set the maximum date to the current date
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                selectedDate = newDateTime;
              });
            },
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        if (widget.onDateSelected != null) {
          widget.onDateSelected!(pickedDate);
          _saveSelectedDate(pickedDate);
        }
      });
    }
  }
}
