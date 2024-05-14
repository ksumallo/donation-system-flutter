import 'package:flutter/material.dart';

class MyCheckbox extends StatefulWidget {
  final String label;
  final bool value;
  final Function(bool)? onToggle;
  final bool? initialState;

  const MyCheckbox(
      {super.key,
      this.label = '',
      this.value = false,
      this.initialState,
      this.onToggle});

  @override
  createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool? isTicked;

  @override
  Widget build(BuildContext context) {
    isTicked = widget.initialState ?? false;

    FormField checkboxField = FormField<bool>(
      initialValue: isTicked,
      builder: (field) {
        return Checkbox(
          value: field.value ?? false,
          onChanged: (newState) {
            field.didChange(newState);
            widget.onToggle?.call(newState!);
          },
        );
      },
    );

    if (widget.label.isEmpty) {
      return checkboxField;
    }

    return Row(
      children: [checkboxField, Text(widget.label)],
    );
  }
}
