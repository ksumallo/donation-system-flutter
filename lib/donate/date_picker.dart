import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MyDatePickerType { number, text }

class MyDatePicker extends StatefulWidget {
  final bool enabled;
  final String label;
  final String initialValue;
  final MyDatePickerType inputType;
  final Function(String)? onTextChange;

  const MyDatePicker(
      {super.key,
      this.initialValue = '',
      this.label = '',
      this.onTextChange,
      this.inputType = MyDatePickerType.text,
      this.enabled = true});

  @override
  createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  DateTime currDate = DateTime.now();
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: '-');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () {
          showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  currentDate: DateTime.now(),
                  lastDate: DateTime(2099))
              .then((value) {
            if (value != null) {
              currDate = value;
              controller.text = DateFormat("MMMM dd, yyyy").format(value);
            }
          });
        },
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            labelText: widget.label),
      ),
    );
  }
}
