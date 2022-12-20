import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:social_share/social_share.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:shared_preferences/shared_preferences.dart';

import '../model/attendee.dart';
import 'Detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List student = [];
  List search = [];

  List<Attendee> attendees = [];
  List<Attendee> filteredAttendees = [];

  late ScrollController _controller;

  bool _flagSearch = false;
  bool _flag = false;

  final nameTextEditing = TextEditingController();
  final phoneTextEditing = TextEditingController();
  final searchTextEditing = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    search.addAll(student);
    addUser();
    loadFormat();
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('You have reached the end of the list'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
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
      var content = await rootBundle
          .loadString('assets/attendance_dataset/attendance.json');
      var response = jsonDecode(content);
      // print(response);

      setState(() {
        student = response;
        student.sort((b, a) {
          var firstDate = a["check-in"];
          var secondDate = b["check-in"];
          return DateTime.parse(firstDate)
              .compareTo(DateTime.parse(secondDate));
        });
      });
    } catch (e) {}
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
            elem['user'].toString().toLowerCase().contains(query.toLowerCase()))
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
                setState(() {
                  setResults(value);
                  _flagSearch = true;
                });
              },
              controller: searchTextEditing,
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                user: search[index]['user'],
                                phone: search[index]['phone'],
                                date: DateFormat("dd MMM yyyy, h:mm a").format(
                                    DateTime.parse(
                                        search[index]['check-in'])))));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 32, bottom: 32, left: 16, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    _flagSearch
                                        ? search[index]['user']
                                        : student[index]['user'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                ),
                                Text(
                                  _flagSearch
                                      ? search[index]['phone']
                                      : student[index]['phone'],
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: 100,
                            child: Text(
                              _flagSearch
                                  ? (_flag
                                      ? timeago.format(DateTime.parse(
                                          search[index]['check-in']))
                                      : DateFormat("dd MMM yyyy, h:mm a")
                                          .format(DateTime.parse(
                                              search[index]['check-in'])))
                                  : (_flag
                                      ? timeago.format(DateTime.parse(
                                          student[index]['check-in']))
                                      : DateFormat("dd MMM yyyy, h:mm a")
                                          .format(DateTime.parse(
                                              student[index]['check-in']))),
                              // '$_counter'
                            ),
                          ),
                          IconButton(
                              onPressed: () async {
                                SocialShare.shareOptions(
                                    student[index]['phone']);
                              },
                              icon: const Icon(Icons.share)),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: _flagSearch
                  ? search == null
                      ? 0
                      : search.length
                  : student == null
                      ? 0
                      : student.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text('Add User'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: nameTextEditing,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            controller: phoneTextEditing,
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
                        style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.blue)),
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          final newDate = DateTime.now();
                          String newFormatDate =
                              DateFormat("yyyy-MM-dd hh:mm:ss").format(newDate);
                          print(newFormatDate);
                          final newStudent = Attendee(
                              user: nameTextEditing.text,
                              phone: phoneTextEditing.text,
                              checkIn: newFormatDate);

                          setState(() {
                            student.add(newStudent.toJson());
                            student.sort((b, a) {
                              var firstDate = a["check-in"];
                              var secondDate = b["check-in"];
                              return DateTime.parse(firstDate)
                                  .compareTo(DateTime.parse(secondDate));
                            });
                          });

                          Navigator.pop(context);
                          print(student);
                        }),
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
