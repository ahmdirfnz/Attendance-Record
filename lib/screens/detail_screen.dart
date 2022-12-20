import 'package:attendance_record/helper/extensions.dart';
import 'package:flutter/material.dart';
import '../model/attendee.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.attendee});

  final Attendee attendee;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detail Page'
          ),
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Name: ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6,),
                  Text(
                     'Phone Number: ',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 6,),
                  Text(
                      'Date: ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.attendee.user,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6,),
                  Text(
                      widget.attendee.phone,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 6,),
                  Text(
                    widget.attendee.checkIn.formattedDate(),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
