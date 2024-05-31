import 'package:final_proj/entities/user.dart';
import 'package:final_proj/pages/organization_list.dart';
import 'package:final_proj/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  final User user;

  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthProvider>().logout().then((_) {
                Navigator.popAndPushNamed(context, '/');
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: context.watch<AuthProvider>().currentUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Existing content
                  Row(
                    children: [
                      const Icon(Icons.account_circle, size: 72),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Username: ${user.username}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Icon(Icons.home, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Addresses:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: user.addresses
                        .map(
                          (address) => Padding(
                            padding: const EdgeInsets.only(left: 32),
                            child: Text(
                              address,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Icon(Icons.phone, size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Contact Number:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.contactNumber,
                    style: const TextStyle(fontSize: 16),
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
                        child: const Text('Donate'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.popAndPushNamed(context, '/');
            });
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
