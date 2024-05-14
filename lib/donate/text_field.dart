import 'package:flutter/material.dart';

enum MyTextFieldType { number, text }

class MyTextField extends StatefulWidget {
  final bool enabled;
  final String label;
  final String initialValue;
  final MyTextFieldType inputType;
  final Function(String)? onTextChange;

  const MyTextField(
      {super.key,
      this.initialValue = '',
      this.label = '',
      this.onTextChange,
      this.inputType = MyTextFieldType.text,
      this.enabled = true});

  @override
  createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: widget.enabled,
        initialValue: widget.initialValue,
        validator: (value) {
          if (value!.isEmpty) {
            return "Cannot be left blank";
          }
          if (widget.inputType == MyTextFieldType.number) {
            return (int.tryParse(value) == null)
                ? "Enter numeric characters only"
                : null;
          }

          return null;
        },
        onChanged: widget.onTextChange,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            labelText: widget.label),
      ),
    );
  }
}
