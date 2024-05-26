import 'dart:io';

import 'package:final_proj/donate/date_picker.dart';
import 'package:final_proj/donate/dialog_add_category.dart';
import 'package:final_proj/donate/dropdown_list.dart';
import 'package:final_proj/donate/text_field.dart';
import 'package:final_proj/donate/time_picker.dart';
import 'package:final_proj/entities/donation.dart';
import 'package:final_proj/entities/organization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key, required Organization organization});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class ItemCategory {
  final String name;
  bool selected;

  ItemCategory({required this.name, this.selected = false});
}

enum DonationMethod { pickUp, dropOff }

class _DonatePageState extends State<DonatePage> {
  Donation donation = Donation();
  XFile? _uploadedImage;
  DonationMethod selectedMethod = DonationMethod.pickUp;

  final List<ItemCategory> _itemCategories = [
    ItemCategory(name: "Food"),
    ItemCategory(name: "Clothes"),
    ItemCategory(name: "Cash"),
    ItemCategory(name: "Necessities"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donate"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: true,
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
                      ..._itemCategories.map((category) => CheckboxListTile(
                          title: Text(category.name),
                          value: category.selected,
                          onChanged: (t) =>
                              setState(() => category.selected = t!))),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text("Add option"),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AddCategoryDialog(
                                  onAccept: (newCategory) => setState(() {
                                        _itemCategories.add(
                                            ItemCategory(name: newCategory));
                                        Navigator.pop(context);
                                      })));
                        },
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: MyTextField(
                        label: "Weight",
                        inputType: MyTextFieldType.number,
                        onTextChange: (weight) =>
                            donation.weight = double.tryParse(weight) ?? 0.0,
                      ),
                    ),
                    Flexible(
                      child: MyDropdownList(
                          choices: Donation.weightUnits,
                          onItemSelected: (choice) {
                            donation.weightUnit = Donation.weightUnits[choice];
                          }),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: MyDatePicker(
                        label: "Delivery Date",
                        onDateChanged: (date) => donation.date = date,
                      ),
                    ),
                    Flexible(
                      child: MyTimePicker(
                        label: "Delivery Time",
                        onTimeChanged: (time) => donation.time = time,
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: donation.isPickup,
                    child: MyTextField(
                      label: "Address",
                      onTextChange: (address) =>
                          donation.addresses.add(address),
                    )),
                MyTextField(
                  label: "Contact Number",
                  inputType: MyTextFieldType.number,
                  onTextChange: (contact) => donation.contact = contact,
                ),
                Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Photo of items to donate"),
                            FilledButton.tonalIcon(
                                icon: const Icon(Icons.add_a_photo),
                                label: const Text("Add Photo"),
                                onPressed: () {
                                  ImagePicker picker = ImagePicker();
                                  Future<XFile?> file = picker.pickImage(
                                      source: ImageSource.gallery);

                                  file.then((value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Image uploaded: ${value!.path}')));
                                    setState(() => donation.image = value);
                                  });
                                })
                          ],
                        ),
                        if (donation.image != null)
                          Image.file(File(donation.image!.path))
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
            SegmentedButton<DonationMethod>(
              segments: const [
                ButtonSegment<DonationMethod>(
                    value: DonationMethod.pickUp,
                    label: Text('Pick-up'),
                    icon: Icon(Icons.local_shipping)),
                ButtonSegment<DonationMethod>(
                  value: DonationMethod.dropOff,
                  label: Text('Drop-off'),
                  icon: Icon(Icons.home),
                )
              ],
              selected: <DonationMethod>{selectedMethod},
              onSelectionChanged: (selected) {
                setState(() {
                  selectedMethod = selected.first;
                  donation.isPickup = selectedMethod == DonationMethod.pickUp;
                });
              },
            ),
            FilledButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Donate"),
              onPressed: () {
                donation.itemCategories = _itemCategories
                    .where((category) => category.selected)
                    .map((category) => category.name)
                    .toList();

                donation.debug();

                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Donation created")));
              },
            ),
          ],
        ),
      ),
    );
  }
}
