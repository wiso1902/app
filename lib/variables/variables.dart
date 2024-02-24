import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

late List<String> globalItems = ['Välj träning'];
String userId = "";
int total = 0;
late FixedExtentScrollController scrollController;
final bool backButton = true;
var index = 0;
bool isChecked = false;
int selectedIndex = 1; // Initialize with default value
DateTime selectedDateTime = DateTime.now(); // Initialize with current date/time
String name = "";
String imagePath1 = "";
int totalTr = 1;
int totalTr1 = 0;
CollectionReference tr = FirebaseFirestore.instance.collection('tr');
CollectionReference top = FirebaseFirestore.instance.collection('top');
CollectionReference totaltr = FirebaseFirestore.instance.collection('total');
late bool ok;
late int totala;
