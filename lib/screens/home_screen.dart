import 'dart:convert';
import 'package:attendance_record/components/add_dialog.dart';
import 'package:attendance_record/helper/extensions.dart';
import 'package:attendance_record/screens/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_share/social_share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/attendee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Attendee> attendees = [];
  List<Attendee> filteredAttendees = [];

  final ScrollController _scrollController = ScrollController();
  final _searchInputController = TextEditingController();
  final String _keyFlagDateFormat = "keyFlagDateFormat";
  bool _flagChangeDateFormat = false;

  @override
  void initState() {
    super.initState();
    _loadAttendees();
    _loadDateFormat();
  }

  void _sortAttendances() {
    attendees.sort((a, b) {
      return DateTime.parse(b.checkIn)
          .compareTo(DateTime.parse(a.checkIn));
    });
  }

  Future _loadAttendees() async {
    try {
      var content = await rootBundle
          .loadString('assets/attendance_dataset/attendance.json');
      var response = jsonDecode(content);

      for (var json in response) {
        var attendee = Attendee.fromJson(json);
        attendees.add(attendee);
      }
      _sortAttendances();
      setState(() {
        filteredAttendees = attendees;
      });

    } catch (e) {}
  }

  void _loadDateFormat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _flagChangeDateFormat = prefs.getBool(_keyFlagDateFormat) ?? false;
    });
  }

  void _changeDateFormat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFlagDateFormat, _flagChangeDateFormat);

    setState(() {
      _flagChangeDateFormat = prefs.getBool(_keyFlagDateFormat) ?? false;
    });
  }

  void _filterFromQuery(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredAttendees = attendees;
      } else {
        filteredAttendees = attendees
            .where((elem) =>
            elem.user.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });

    print(filteredAttendees.length);
  }

  void _addAttendee(Attendee attendee) {
    setState(() {
      attendees.add(attendee);
      _sortAttendances();
    });
  }

  void _openDetailScreen(Attendee attendee) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(attendee: attendee)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            child: const Text(
              'Change Date Format',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _flagChangeDateFormat = !_flagChangeDateFormat;
              _changeDateFormat();
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
                _filterFromQuery(value);
              },
              controller: _searchInputController,
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
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                var attendee = filteredAttendees[index];
                return Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: Column(
                    children: [
                      Card(
                        child: InkWell(
                          onTap: () => _openDetailScreen(attendee),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 24, right: 16, top: 24, bottom: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        attendee.user,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      Text(
                                        attendee.phone,
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                      _flagChangeDateFormat
                                          ? timeago.format(DateTime.parse(
                                              attendee.checkIn))
                                          : attendee.checkIn.formattedDate(), textAlign: TextAlign.right,),
                                const SizedBox(width: 16),
                                IconButton(
                                    onPressed: () async {
                                      SocialShare.shareOptions(attendee.phone);
                                    },
                                    icon: const Icon(Icons.share)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (index == filteredAttendees.length - 1)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('You have reached the end of the list'),
                        )
                    ],
                  ),
                );
              },
              itemCount: filteredAttendees.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddDialog(onCreateAttendee: (attendee) {
                  _addAttendee(attendee);
                  print(attendee.user);
                });
              });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
