import 'package:final_proj/entities/user.dart';
import 'package:final_proj/pages/organization_list.dart';
import 'package:final_proj/pages/user_profile.dart';
import 'package:final_proj/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserApp extends StatefulWidget {
  final User user;

  const UserApp({super.key, required this.user});

  @override
  State<UserApp> createState() => _UserAppState();
}

class _UserAppState extends State<UserApp> {
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
  Widget build(BuildContext context) {
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
        children: [const OrganizationList(), UserProfile(user: widget.user)],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Organizations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
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
