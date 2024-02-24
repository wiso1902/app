import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:why_appen/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:why_appen/list_view_top/list_view_top.dart';
import 'package:why_appen/save_traning/spara_tr_list.dart';
import 'package:why_appen/upload_tr/build_dialog.dart';
import 'package:why_appen/upload_tr/set_data_tr.dart';
import 'package:why_appen/user_status/user_status.dart';
import 'package:why_appen/variables/variables.dart';
import 'create_user_page/create_user_page.dart';
import 'list_view/tr_view.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          dividerColor: Colors.black,
          primaryColor: Colors.orangeAccent,
          primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const MyScreen(),
      ),
    );
  }
}

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  TextEditingController trController = TextEditingController();

  //-------------------------------INIT APP--------------------------------------------

  Future<void> loadSelectedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? dateStringList = prefs.getStringList('selectedDates');
    print('Loaded date strings: $dateStringList'); // Debug print
    setState(() {
      selectedDates = (dateStringList ?? []).map((dateString) {
        DateTime parsedDate = DateTime.parse(dateString).toLocal();
        return DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
      }).toList();
      print('Selected dates: $selectedDates'); // Debug print
    });
  }

  Future<void> saveSelectedDates() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dateStringList = selectedDates
        .map((date) => DateFormat('yyyy-MM-dd').format(date.toLocal()))
        .toList();
    await prefs.setStringList('selectedDates', dateStringList);
  }

  void addDateToList(DateTime date) {
    if (!selectedDates.contains(date)) {
      setState(() {
        selectedDates.add(date);
        saveSelectedDates(); // Update SharedPreferences
      });
    }
  }

  fetchUserID() async {
    User getUser = FirebaseAuth.instance.currentUser!;
    userId = getUser.uid;
  }

  fetchItems() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('val').doc('items').get();
    dynamic itemsData = ds.get('items'); // Assuming items is initially fetched as dynamic
    if (itemsData is List<dynamic>) {
      items = itemsData.cast<String>(); // Cast to List<String>
    } else {
      // Handle error or set items to an empty list
      items = [];
    }
  }

  getNameAndImage() async {
    fetchUserID();
    DocumentSnapshot ds =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    name = ds.get('name');
    imagePath = ds.get('imagePath');
  }

  getTotala() async {
    DocumentSnapshot ds =
    await FirebaseFirestore.instance.collection('total').doc('total').get();
    totala = ds.get('total');
  }

  getUserScore() async {
    DocumentSnapshot ds =
    await FirebaseFirestore.instance.collection('top').doc(userId).get();
    totalTr1 = ds.get('totalTr');
    return totalTr1;
  }

  getOk() async {
    fetchUserID();
    FirebaseFirestore.instance
        .collection('top')
        .doc(userId)
        .get()
        .then((onExists) {
      onExists.exists ? ok = true : ok = false;
    });
  }

  getTotal() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('total')
        .doc('total')
        .get();
    int totalInt;
    totalInt = ds.get('total');
    setState(() {
      total = (totalInt * 20);
    });
  }

  final Stream<QuerySnapshot> trViewDate = FirebaseFirestore.instance
      .collection('tr')
      .orderBy('tid', descending: true)
      .snapshots();

  final Stream<QuerySnapshot> trViewTop = FirebaseFirestore.instance
      .collection('top')
      .orderBy('totalTr', descending: true)
      .snapshots();

  void printDate() {
    print(dateTime);
  }

  @override
  void initState() {
    super.initState();
    getOk();
    loadSelectedDates();
    printDate();
    getTotal();
    getNameAndImage();
    fetchUserID();
    fetchItems();
    getTotala();
    getUserScore();
    scrollController = FixedExtentScrollController(initialItem: index);
  }
  //-------------------------------INIT APP--------------------------------------------

  //-------------------------------BODY------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              icon: const Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.orangeAccent,
              ),
              tooltip: 'Logga ut',
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Why Appen",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                // Execute asynchronous operation
                final result = await checkSignInStatus(context);
                if (result == true) {
                  // User is signed in, navigate to settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => create_user_page(
                        userId: userId,
                        enableBackButton: true,
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(
                FontAwesomeIcons.gear,
                color: Colors.orangeAccent,
              ),
              tooltip: 'Inställningar',
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.orangeAccent, // Choose your border color
                width: 4, // Choose the border width
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedDigitWidget(
                  value: total,
                  // or use controller
                  textStyle: const TextStyle(fontSize: 60),
                  enableSeparator: true,
                  separateSymbol: " ",
                  separateLength: 3,
                ),
                const Text(
                  "kr",
                  style: TextStyle(fontSize: 24), // Adjust font size as needed
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight, // Ensures it takes up all available space
            child: isChecked ? build_stream_top(trViewTop: trViewTop) : build_stream_tr(trViewDate: trViewDate),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.plus,
                color: Colors.orangeAccent,
                size: 20,
              ),
              label: "Lägg till träning"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.arrowUp,
                color: Colors.orangeAccent,
                size: 20,
              ),
              label: "Topplista"),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.personRunning,
                color: Colors.orangeAccent,
                size: 20,
              ),
              label: "Saknas en träning?")
        ],
        onTap: (int idx) async {
          switch (idx) {
            case 0:
              Future<Object?> result = checkSignInStatus(context);
              result.then((value) {
                if (value == true) {
                  // User is signed in, show an alert dialog
                  showAlertDialog(
                    context,
                    items,
                    index,
                    dateTime,
                    selectedDates,
                    trController,
                    getTotal,
                    addDateToList,
                    setDataTr,
                    setDataTop,
                    tr,
                    name,
                    imagePath,
                    userId,
                    selectedIndex, // Pass selectedIndex
                    selectedDateTime, // Pass selectedDateTime
                  );

                }
              });
              break;
            case 1:
              setState(() => isChecked = !isChecked);
              break;
            case 2:
              Future<Object?> result = checkSignInStatus(context);
              result.then((value) {
                if (value == true) {
                  // User is signed in, show an alert dialog
                  showCreateTr(context, trController);
                }
              });
              break;
          }
        },
      ),
    );
  }
  //-------------------------------BODY------------------------------------------------

//_________________________________SPARA TRÄING----------------------------------------
  List<DateTime> selectedDates = [];
  DateTime dateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  ); // Initialize with just the date part
  late DateTime selectedDate = DateTime.now();

  setDataTop() async {
    getOk();
    getUserScore();
    getTotala();
    if (ok == false) {
      top.doc(userId)
          .set({
            'totalTr': totalTr,
            'name': name,
            'imagePath': imagePath,
            'userID': userId,
          })
          .then((value) => print('Top added'))
          .catchError((error) => Fluttertoast.showToast(
              msg: 'error $error',
              textColor: Colors.orange,
              backgroundColor: Colors.white));
    } else if (ok == true) {
      top.doc(userId)
          .update({
            'totalTr': totalTr1 + 1,
            'name': name,
            'imagePath': imagePath,
            'userID': userId,
          })
          .then((value) => print('Top update'))
          .catchError((error) => Fluttertoast.showToast(
              msg: 'error $error',
              textColor: Colors.orange,
              backgroundColor: Colors.white));
    }
    totaltr.doc('total')
        .update({
          'total': totala + 1,
        })
        .then((value) => print('Top update'))
        .catchError((error) => Fluttertoast.showToast(
            msg: 'error $error',
            textColor: Colors.orange,
            backgroundColor: Colors.white));
  }
  //_________________________________SPARA TRÄING----------------------------------------
}
