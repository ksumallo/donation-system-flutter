import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  final String label, value;
  final IconData? icon;

  const ProfileInfoTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(child: ListTile(
      leading: (icon != null) ? Icon(icon) : null,
      title: Text(label),
      subtitle: Text(value),
    )
    );
  }
}