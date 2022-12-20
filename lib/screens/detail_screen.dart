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
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detail Page'
          ),
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
          },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: [
            Text(widget.attendee.user),
            Text(widget.attendee.phone),
            Text(widget.attendee.checkIn),
          ],
        ),
      ),
    );
  }
}
