import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_preferences/shared_preferences.dart';
// import 'add_new_user.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'main_screen',
      routes: {
        'main_screen': (context) => const MyHomePage(title: 'Attendance Record App'),
        // 'newUser_screen': (context) => const NewUser(),
      },
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

List <NewUser> student = [];

class NewUser {
  late String name;
  late String phone;
  late String date;


  NewUser(
    this.name,
      this.phone,
      this.date,
);

  NewUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['date'] = this.date;

    return data;
  }
}

class _MyHomePageState extends State<MyHomePage> {

  bool _flagA = false;
  int _counter = 0;
  final studentName = TextEditingController();
  final studentPhone = TextEditingController();

  List<bool> flag = <bool>[];

  @override
  void initState() {
    super.initState();
    // _loadBool();
    loadFavorite();
    // saved(new_flag, index);
  }

  // void _loadBool() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     // _counter = (prefs.getInt('counter') ?? 0);
  //
  //   });
  //   _flagA = !(prefs.getBool('flagA') ?? false);
  //   print(_flagA);
  //
  // }

  Future<void> loadFavorite() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      flag = (prefs.getStringList("flag") ?? <bool>[]).map((value) => value == 'true').toList();
    });
  }

  void _savebool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

    });
    _flagA = !(prefs.getBool('flagA') ?? false);
    prefs.setBool('flagA', _flagA);
    print(_flagA);


  }

  Future<void> saved(int index, bool newflag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      flag[index] = newflag;
    });
    await prefs.setStringList("flag", flag.map((value) => value.toString()).toList());
    setState(() {
      flag = (prefs.getStringList("flag") ?? <bool>[]).map((value) => value == 'true').toList();
    });
  }

  Future addUser(File file) async {
    String contents = await file.readAsString();
    var jsonResponse = jsonDecode(contents);



    for(var p in jsonResponse){

      NewUser newUser = NewUser(p['name'],p['phone'],p['date']);
      student.add(newUser);
    }

  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
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
                                  flag[index] ? timeago.format(DateTime.parse(newData[index]['check-in'])) : newData[index]['check-in']
                                // '$_counter'
                              ),
                            onPressed: () async {
                                // _savebool();
                              flag[index] = !flag[index];
                              saved(index, flag[index]);

                              // setState(() {
                              //   flag[index] = !flag[index];
                              //   saved(flag[index], index);
                              //   _flagA = !_flagA;
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
                            decoration: InputDecoration(
                              labelText: 'Name',
                              icon: Icon(Icons.account_box),
                            ),
                          ),
                          TextFormField(
                            controller: studentPhone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              icon: Icon(Icons.phone),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    RaisedButton(
                      color: Colors.blue,
                        child: Text("Add", style: TextStyle(color: Colors.white),),
                        onPressed: () async {
                        final newDate = DateTime.now();
                        String newFormatDate = DateFormat('dd MMM yyyy, h:mm a').format(newDate);
                        final Directory? directory = await getExternalStorageDirectory();
                        final path = await _localPath;
                        final File file = File('$path/assets/attendance_dataset/attendance.json');
                        await addUser(file);
                        final newStudent = NewUser(
                            studentName.text,
                            studentPhone.text,
                            newFormatDate,
                        );
                        student.add(newStudent);
                        student.map((newUser) => newUser.toJson()).toList();
                        file.writeAsStringSync(json.encode(student));
                        Navigator.pushNamed(context, 'main_screen');

                          // your code
                        })
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
