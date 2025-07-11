import 'package:flutter/material.dart';

class AddressWidget extends StatefulWidget {
  final void Function(List<String>) onAddressChanged;

  AddressWidget({required this.onAddressChanged});

  @override
  _AddressWidgetState createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final List<TextEditingController> _addressControllers = [
    TextEditingController()
  ];

  @override
  void dispose() {
    for (var controller in _addressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAddressField() {
    setState(() {
      _addressControllers.add(TextEditingController());
    });
    _notifyAddressesChanged();
  }

  void _notifyAddressesChanged() {
    final addresses =
        _addressControllers.map((controller) => controller.text).toList();
    widget.onAddressChanged(addresses);
  }

  Widget _buildAddressField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _addressControllers[index],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Address",
                hintText: "Enter address",
                prefixIcon: Icon(Icons.home),
              ),
              onChanged: (value) => _notifyAddressesChanged(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Address is required";
                }
                return null;
              },
            ),
          ),
          if (index != 0)
            IconButton(
              onPressed: () {
                setState(() {
                  _addressControllers.removeAt(index);
                });
                _notifyAddressesChanged();
              },
              icon: const Icon(Icons.remove),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < _addressControllers.length; i++)
          _buildAddressField(i),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: _addAddressField,
              icon: const Icon(Icons.add),
            ),
          ]
        )
      ],
    );
  }
}
