import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Attendance Record App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _flagA = false;
  int _counter = 0;

  // List<bool> flag = [false, false, false, false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _loadBool();
    // saved(new_flag, index);
  }

  void _loadBool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // _counter = (prefs.getInt('counter') ?? 0);

    });
    _flagA = !(prefs.getBool('flagA') ?? false);
    print(_flagA);

  }

  void _savebool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('function has been called');
    setState(() {

      // _counter = ((prefs.getInt('counter') ?? 0) + 1);
      // prefs.setInt('counter', _counter);
    });
    _flagA = !(prefs.getBool('flagA') ?? false);
    prefs.setBool('flagA', _flagA);
    print(_flagA);


  }

  // Future<void> saved(bool new_flag, int index) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('flagFormat$index', new_flag);
  //   setState(() {
  //     flag[index] = new_flag;
  //   });
  //   await prefs.setStringList("flagFormat", flag.map((value) => value.toString()).toList());
  //   setState(() {
  //     flag = (prefs.getStringList("flagFormat") ?? <bool>[]).map((value) => value == 'true').toList();
  //   });
  //   print(flag[index]);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString('assets/attendance_dataset/attendance.json'),
          builder: (context, snapshot) {
            var newData = json.decode(snapshot.data.toString());

            newData.sort((a,b) {
              var firstDate = a["check-in"];
              var secondDate = b["check-in"];
              return DateTime.parse(firstDate).compareTo(DateTime.parse(secondDate));
            });

            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 32, bottom: 32, left: 16, right: 16
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {},
                              child:
                              Text(
                                newData[index]['user'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                            Text(newData[index]['phone'], style: TextStyle(color: Colors.grey.shade600),),


                          ],
                        ),
                        Container(
                          height: 50,
                          width: 90,
                          child: TextButton(
                              child: Text(
                                  _flagA ? timeago.format(DateTime.parse(newData[index]['check-in'])) : newData[index]['check-in']
                                // '$_counter'
                              ),
                            onPressed: () async {
                                _savebool();

                              // setState(() {
                                // flag[index] = !flag[index];
                                // saved(flag[index], index);
                                // _flagA = !_flagA;
                              //   _savebool();
                              // });
                              // SharedPreferences prefs = await SharedPreferences.getInstance();
                              // prefs.setStringList("flagFormat", flag.map((value) => value.toString()).toList());


                            },

                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: newData == null ? 0 : newData.length,
            );
          },
        )


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
