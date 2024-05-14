import 'package:flutter/material.dart';

class MyDropdownList extends StatefulWidget {
  final List<String> choices;
  final Function(int) onItemSelected;
  final int selectedInitial;

  const MyDropdownList(
      {super.key,
      this.selectedInitial = 0,
      required this.choices,
      required this.onItemSelected});

  @override
  createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<MyDropdownList> {
  late int selected;

  void onItemSelected(int selectedIndex) {
    setState(() => selected = selectedIndex);

    widget.onItemSelected(selectedIndex);
  }

  @override
  void initState() {
    selected = widget.selectedInitial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
              value: widget.choices[selected],
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: widget.choices
                  .map((choice) => DropdownMenuItem<String>(
                      value: choice, child: Text(choice)))
                  .toList(),
              onChanged: (newValue) => true)
          // FormField(
          //   initialValue: selected,
          //   builder: (field) => DropdownButtonFormField(

          //     value: field.value,
          // items: List.generate(
          //   widget.choices.length,
          //   (index) => DropdownMenuItem<int>(
          //     value: index,
          //     child: Text(widget.choices[index]),
          //   ),
          // ),
          //     onChanged: (newValue) {
          //       field.didChange(newValue);
          //       widget.onItemSelected(newValue!);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
