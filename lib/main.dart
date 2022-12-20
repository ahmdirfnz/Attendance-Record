import 'package:after_layout/after_layout.dart';
import 'package:attendance_record/screen/Detail_screen.dart';
import 'package:attendance_record/screen/Onboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance_record/model/attendance.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:social_share/social_share.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var _doneOnboarding = false;

  void _checkShowOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var doneOnboarding = (prefs.getBool('done_onboarding') ?? false);
    setState(() {
      _doneOnboarding = doneOnboarding;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkShowOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: 'main_screen',
      routes: {
        'main_screen': (context) => const MyHomePage(),
        'onboard_screen': (context) => const OnboardingScreen(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: _doneOnboarding ? MyHomePage() : OnboardingScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage>{

  List student = [];
  List search = [];

  late ScrollController _controller;

  bool _flagSearch = false;

  bool _flag = false;
  final studentName = TextEditingController();
  final studentPhone = TextEditingController();
  final searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    search.addAll(student);
    // _loadBool();
    addUser();
    loadFormat();
    // saved(new_flag, index);
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      Navigator.pushNamed(context, 'main_screen');
    } else {
      await prefs.setBool('seen', true);
      Navigator.pushNamed(context, 'onboard_screen');
    }
  }


  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('You have reached the end of the list'),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _showToast(context);
      });
    }
  }


  Future addUser() async {

    try {
      var content =  await rootBundle.loadString('assets/attendance_dataset/attendance.json');
      var response = jsonDecode(content);
      // print(response);
      setState(() {
        student = response;
        student.sort((b,a) {
          var firstDate = a["check-in"];
          var secondDate = b["check-in"];
          return DateTime.parse(firstDate).compareTo(DateTime.parse(secondDate));
        });
      });

      // print(student);
    } catch(e) {
    }
  }

  Future<void> loadFormat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _flag = prefs.getBool("flag") ?? false;
    });
  }

  Future<void> flagFormat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("flag", _flag);

    setState(() {
      _flag = prefs.getBool("flag") ?? false;
    });
    print(_flag);
  }


  void setResults(String query) {
    search = student
        .where((elem) =>
    elem['user']
        .toString()
        .toLowerCase()
        .contains(query.toLowerCase()))
        .toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text(
              'Change Format',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _flag = !_flag;
              flagFormat();

            },
          ),
        ],
        title: const Text('Attendance Record'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                // filterSearchResults(searchController.text);
                setState(() {
                  setResults(value);
                  _flagSearch = true;
                });


              },
              controller: searchController,
              decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(user: search[index]['user'], phone: search[index]['phone'], date: DateFormat("dd MMM yyyy, h:mm a").format(DateTime.parse(search[index]['check-in'])))));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 32, bottom: 32, left: 16, right: 20
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child:
                                        Text(
                                         _flagSearch ? search[index]['user'] : student[index]['user'],
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                        ),
                                      ),
                                      Text(_flagSearch ? search[index]['phone'] : student[index]['phone'], style: TextStyle(color: Colors.grey.shade600),),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 100,
                                  child: Text(
                                     _flagSearch ? (_flag ? timeago.format(DateTime.parse(search[index]['check-in'])) : DateFormat("dd MMM yyyy, h:mm a").format(DateTime.parse(search[index]['check-in']))) :
                                     (_flag ? timeago.format(DateTime.parse(student[index]['check-in'])) : DateFormat("dd MMM yyyy, h:mm a").format(DateTime.parse(student[index]['check-in']))),
                                    // '$_counter'
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      SocialShare.shareOptions(student[index]['phone']);
                                    },
                                    icon: const Icon(Icons.share)

                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _flagSearch ? search ==  null ? 0 : search.length : student ==  null ? 0 : student.length,
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, 'newUser_screen');
          // addUser();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Add User'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: studentName,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            controller: studentPhone,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              icon: Icon(Icons.phone),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(textStyle: TextStyle(color: Colors.blue)),
                        child: Text("Add", style: TextStyle(color: Colors.white),),
                        onPressed: () async {
                        final newDate = DateTime.now();
                        String newFormatDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(newDate);
                        print(newFormatDate);
                        final newStudent = Attendance(user: studentName.text, phone: studentPhone.text, checkIn: newFormatDate);

                        setState(() {
                          student.add(newStudent.toJson());
                          student.sort((b,a) {
                            var firstDate = a["check-in"];
                            var secondDate = b["check-in"];
                            return DateTime.parse(firstDate).compareTo(DateTime.parse(secondDate));
                          });
                        });

                        Navigator.pop(context);

                        print(student);
                        // student.map((newUser) => newUser.toJson()).toList();
                        // file.writeAsStringSync(json.encode(student));
                        // Navigator.pushNamed(context, 'main_screen');

                          // your code
                        }
                        ),
                  ],
                );
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
