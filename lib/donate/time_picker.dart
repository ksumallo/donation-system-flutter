import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MyTimePickerType { number, text }

class MyTimePicker extends StatefulWidget {
  final bool enabled;
  final String label;
  final MyTimePickerType inputType;
  final Function(String)? onTextChange;

  const MyTimePicker(
      {super.key,
      this.label = '',
      this.onTextChange,
      this.inputType = MyTimePickerType.text,
      this.enabled = true});

  @override
  createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  TimeOfDay currTime = const TimeOfDay(hour: 0, minute: 0);
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
          showTimePicker(context: context, initialTime: currTime).then((value) {
            if (value != null) {
              currTime = value;
              controller.text = (value).format(context);
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
