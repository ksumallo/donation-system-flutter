import 'package:final_proj/donate/date_picker.dart';
import 'package:final_proj/donate/dropdown_list.dart';
import 'package:final_proj/donate/text_field.dart';
import 'package:final_proj/donate/time_picker.dart';
import 'package:final_proj/entities/organization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key, required Organization organization});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donate"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.done),
        //     tooltip: "Create donation",
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Card.outlined(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(top: 12.0, left: 16.0, bottom: 4.0),
                        child: Text("Item Categories"),
                      ),
                      CheckboxListTile(
                          title: const Text("Food"),
                          value: false,
                          onChanged: (t) => true),
                      CheckboxListTile(
                          title: const Text("Clothes"),
                          value: false,
                          onChanged: (t) => true),
                      CheckboxListTile(
                          title: const Text("Cash"),
                          value: false,
                          onChanged: (t) => true),
                      CheckboxListTile(
                          title: const Text("Necessities"),
                          value: false,
                          onChanged: (t) => true),
                      ListTile(
                        onTap: () {},
                        leading: const Icon(Icons.add),
                        title: const Text("Add option"),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Flexible(
                      flex: 3,
                      child: MyTextField(
                        label: "Weight",
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: MyDropdownList(
                          choices: const ["kg", "lb"], onItemSelected: (i) {}),
                    )
                  ],
                ),
                const Row(
                  children: [
                    Flexible(
                      child: MyDatePicker(
                        label: "Delivery Date",
                      ),
                    ),
                    Flexible(
                      child: MyTimePicker(
                        label: "Delivery Time",
                      ),
                    ),
                  ],
                ),
                const MyTextField(
                  label: "Address (for pick-up)",
                ),
                const MyTextField(
                  label: "Contact Number",
                ),
                Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Photo of items to donate"),
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.add_a_photo),
                          label: const Text("Add Photo"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SegmentedButton(
              segments: const [
                ButtonSegment(value: "Pick-up", label: Text("Pick-up")),
                ButtonSegment(value: "Drop-off", label: Text("Drop-off"))
              ],
              selected: const {"Pick-up"},
              onSelectionChanged: (selected) {},
            ),
            FilledButton.icon(
                icon: Icon(Icons.send),
                onPressed: () {},
                label: const Text("Donate")),
          ],
        ),
      ),
    );
  }
}
