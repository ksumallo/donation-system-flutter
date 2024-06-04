import 'dart:developer';

import 'package:final_proj/entities/organization.dart';
import 'package:final_proj/pages/donate_page.dart';
import 'package:final_proj/pages/organization_list.dart';
import 'package:final_proj/pages/organization_profile.dart';
import 'package:final_proj/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationDetails extends StatefulWidget {
  final Organization org;

  const OrganizationDetails({super.key, required this.org});

  @override
  State<OrganizationDetails> createState() => _OrganizationDetailsState();
}

class _OrganizationDetailsState extends State<OrganizationDetails> {
  int _currentPage = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 56 * 3,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.org.name),
              background: const Icon(Icons.ac_unit_sharp),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(widget.org.description),
                  const SizedBox(height: 24),
                  FilledButton(
                    child: const Text('Donate'),
                    onPressed: () => 
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DonatePage(receipient: widget.org))),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
