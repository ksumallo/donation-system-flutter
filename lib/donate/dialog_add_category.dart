import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  Function(String)? onAccept;

  AddCategoryDialog({super.key, this.onAccept});

  @override
  createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Add new category"),
        content: TextField(
          controller: _categoryController,
          decoration: const InputDecoration(
            hintText: 'Enter category name',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () =>
                  widget.onAccept?.call(_categoryController.text.trim()),
              // () => ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text("Category added"))),
              child: const Text("Add"))
        ]);

    // return AlertDialog(
    //   title: Text('Add Category'),
    //   content: TextField(),
    //   actions: [
    //     FlatButton(
    //       child: Text('Cancel'),
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //     FlatButton(
    //       child: Text('Add'),
    //       onPressed: () {
    //         String categoryName = _categoryController.text.trim();
    //         // Perform category addition logic here
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //   ],
    // );
  }
}
