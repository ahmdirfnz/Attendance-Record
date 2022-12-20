import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/attendee.dart';

class AddDialog extends StatefulWidget {
  const AddDialog({Key? key}) : super(key: key);

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {

  final nameFieldController = TextEditingController();
  final phoneFieldController = TextEditingController();

  bool _disableAddButton() {
    return nameFieldController.text.isEmpty || phoneFieldController.text.isEmpty;
  }

  void _addAttendee() {
    final newDate = DateTime.now();
    String newFormatDate =
    DateFormat("yyyy-MM-dd hh:mm:ss").format(newDate);
    print(newFormatDate);
    final attendee = Attendee(
        user: nameFieldController.text,
        phone: phoneFieldController.text,
        checkIn: newFormatDate);

    Navigator.pop(context);
  }

  void _updateButton() {
    setState(() {
      _disableAddButton();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Add User'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                onChanged: (value) {
                  _updateButton();
                },
                controller: nameFieldController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.account_box),
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  _updateButton();
                },
                controller: phoneFieldController,
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
        TextButton(onPressed: () {Navigator.pop(context);}, child: Text('Cancel')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(color: Colors.blue)),
            onPressed: _disableAddButton() ? null : () => _addAttendee(),
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.white),
            )
        ),
      ],
    );
  }
}
