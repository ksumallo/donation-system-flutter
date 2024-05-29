import 'package:final_proj/pages/organization_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'donors_list.dart';
class AdminApp extends StatefulWidget {

  const AdminApp();

  @override
  createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build (BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          if (_currentPage == 1) IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context
                  .read<AuthProvider>()
                  .logout()
                  .then((value) => Navigator.popAndPushNamed(context, '/'));
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [const OrganizationList(), const OrganizationList(), DonorsList()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fact_check),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Donors',
          ),
        ],
        onTap: (index) => onNavigateTap(index),
      ),
    );
  }

  onNavigateTap(int i) {
    setState(() {
      _currentPage = i;
      _pageController.animateToPage(
          i,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic);
    });
  }
}