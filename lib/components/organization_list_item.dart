import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrgListItem extends StatelessWidget {
  final String name;
  final String? description;
  final bool open;
  final Function()? onTap;

  OrgListItem({
    super.key,
    required this.name,
    this.description,
    this.open = false,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      clipBehavior: Clip.hardEdge,
        child: ListTile(
          trailing: Icon(open ? Icons.check : Icons.close),
          title: Text(name),
          subtitle: Text(description ?? ''),
          onTap: onTap,
        )
    );
  }
}
