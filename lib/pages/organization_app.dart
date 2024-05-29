import 'dart:developer';

import 'package:final_proj/entities/organization.dart';
import 'package:final_proj/pages/organization_list.dart';
import 'package:final_proj/pages/organization_profile.dart';
import 'package:final_proj/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationApp extends StatefulWidget {
  final Organization org;

  const OrganizationApp({super.key, required this.org});

  @override
  State<OrganizationApp> createState() => _OrganizationAppState();
}

class _OrganizationAppState extends State<OrganizationApp> {
  int _currentPage = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context
                  .read<AuthProvider>()
                  .logout()
                  .then((value) => Navigator.popAndPushNamed(context, '/'));
            },
          )
        ],
      ),
      body: [const OrganizationList(), OrganizationProfile(org: widget.org)][_currentPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Donations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Profile',
          ),
        ],
        onTap: (value) {
          setState(() => _currentPage = value);
          log(value.toString());
        },
      ),
    );
  }
}
