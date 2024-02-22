import 'dart:async';
import 'package:why_appen/auth_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:why_appen/save_traning/spara_tr_list.dart';
import 'package:why_appen/sign_in_page/sign_in_page.dart';
import 'package:why_appen/widgets/palatte.dart';
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
          create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
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
  late List items = ['Välj träning'];
  late int total = 0;
  late FixedExtentScrollController scrollController;
  DateTime dateTime = DateTime.now();
  var index = 0;
  late DateTime selectedDate = DateTime.now();

  Future<void> checkSignInStatus(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not signed in, navigate to the sign-in page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    } else {
      showAlertDialog(context);
    }
  }

  Future<void> loadSelectedDates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedDates = (prefs.getStringList('selectedDates') ?? [])
          .map((dateString) => DateTime.parse(dateString))
          .toList();
    });
  }

  Future<void> saveSelectedDates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'selectedDates',
      selectedDates.map((date) => date.toIso8601String()).toList(),
    );
  }

  String getText() {
    return DateFormat('yyyy-MM-dd').format(dateTime);
    }

  fetchItems() async {
    DocumentSnapshot ds =
        await FirebaseFirestore.instance.collection('val').doc('items').get();
    items = ds.get('items');
  }

  getTotal() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('total')
        .doc('nummer')
        .get();
    int totalInt;
    totalInt = ds.get('d');
    setState(() {
      total = (totalInt * 20);
    });
  }

  final Stream<QuerySnapshot> trViewDate = FirebaseFirestore.instance
      .collection('tr')
      .orderBy('tid', descending: true)
      .snapshots();

  @override
  void initState() {
    super.initState();
    loadSelectedDates();
    getTotal();
    fetchItems();
    scrollController = FixedExtentScrollController(initialItem: index);
  }
  //-------------------------------INIT APP--------------------------------------------

  //-------------------------------BODY------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          "Why Appen",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )),
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
            child: build_stream_tr(trViewDate: trViewDate),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.personRunning,
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
                FontAwesomeIcons.plus,
                color: Colors.orangeAccent,
                size: 20,
              ),
              label: "Saknas en träning?")
        ],
        onTap: (int idx) {
          switch (idx) {
            case 0:
              checkSignInStatus(context);
              break;
            case 1:
              context.read<AuthenticationService>().signOut();
              break;
            case 2:
              showCreateTr(context, trController);
              break;
          }
        },
      ),
    );
  }
  //-------------------------------BODY------------------------------------------------


//_________________________________SPARA TRÄING----------------------------------------
  List<DateTime> selectedDates = [];

  Widget buildDatePicker() => SizedBox(
        height: 350,
        child: CupertinoDatePicker(
          minimumYear: DateTime.now().year,
          maximumYear: DateTime.now().year,
          maximumDate: DateTime.now(),
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
        ),
      );

  Widget buildPickerTr() => SizedBox(
        height: 350,
        child: CupertinoPicker(
            scrollController: scrollController,
            itemExtent: 64,
            selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
              background: CupertinoColors.activeOrange.withOpacity(0.2),
            ),
            onSelectedItemChanged: (index) {
              setState(() => this.index = index);
            },
            children: List.generate(items.length, (index) {
              final item = items[index];
              return Center(
                  child: Text(
                item,
                style: const TextStyle(fontSize: 32),
              ));
            })),
      );

  showAlertDialog(BuildContext context) => showDialog(
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
                                actions: [buildPickerTr()],
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() => items[index]);
                                  },
                                ),
                              ));
                    }),
                CupertinoButton(
                    child: Text(getText(),
                        style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      dateTime = DateTime.now();
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                                actions: [buildDatePicker()],
                                cancelButton: CupertinoActionSheetAction(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    setState(() => getText());
                                  },
                                ),
                              ));
                    }),
                TextButton(
                  onPressed: () {
                    if (!selectedDates.contains(dateTime)) {
                      setState(() {
                        Navigator.pop(context, 'OK');
                        getTotal();
                        selectedDates.add(dateTime);
                        saveSelectedDates();
                      });
                    } else {
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
                        desc: "Du har redan sparat en träning med datumet $dateShow testa ett nytt datum",
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
  //_________________________________SPARA TRÄING----------------------------------------

}

