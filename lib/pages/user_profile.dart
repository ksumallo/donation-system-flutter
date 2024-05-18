import 'package:final_proj/pages/organization_list.dart';
import 'package:flutter/material.dart';

class UserDetails {
  final String name;
  final String username;
  final List<String> addresses;
  final String contactNumber;

  UserDetails({
    required this.name,
    required this.username,
    required this.addresses,
    required this.contactNumber,
  });
}

class UserProfile extends StatelessWidget {
  final UserDetails user;

  const UserProfile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Existing content
            Row(
              children: [
                Icon(Icons.account_circle, size: 72),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Username: ${user.username}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.home, size: 24),
                SizedBox(width: 8),
                Text(
                  'Addresses:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: user.addresses
                  .map((address) => Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Text(
                          address,
                          style: TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.phone, size: 24),
                SizedBox(width: 8),
                Text(
                  'Contact Number:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              user.contactNumber,
              style: TextStyle(fontSize: 16),
            ),
            // additional donate button
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrganizationList(),
                      ),
                    );
                  },
                  child: Text('Donate'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}