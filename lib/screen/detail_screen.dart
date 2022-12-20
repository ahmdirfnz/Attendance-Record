import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.user, required this.phone, required this.date});

  final String user, phone, date;

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
        ),
        body: Column(
          children: [
            Text(widget.user),
            Text(widget.phone),
            Text(widget.date),
          ],
        ),
      ),
    );
  }
}
