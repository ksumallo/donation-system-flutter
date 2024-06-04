
import 'package:final_proj/components/profile_info_tile.dart';
import 'package:final_proj/entities/user.dart';
import 'package:final_proj/pages/organization_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../entities/user.dart';
import '../providers/auth_provider.dart';
import 'organization_list.dart';
import 'create_organization_page.dart';

class UserProfile extends StatelessWidget {
  final User user;

  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Existing content
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                          Icons.account_circle,
                          size: 72)
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                            fontSize:
                                Theme.of(context).textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(user.username,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: user.addresses
          //       .map((address) => Padding(
          //             padding: const EdgeInsets.only(left: 32),
          //             child: Text(
          //               address,
          //               style: const TextStyle(fontSize: 16),
          //             ),
          //           ))
          //       .toList(),
          // ),
          ListView(
            shrinkWrap: true,
            children: [
              ...user.addresses.asMap().entries.map((address) =>
                ProfileInfoTile(label: 'Address ${address.key+1}', value: address.value)),
              ProfileInfoTile(label: "Contact", value: user.contactNumber)
            ],
          ),
          // const Row(
          //   children: [
          //     Icon(Icons.phone, size: 24),
          //     SizedBox(width: 8),
          //     Text(
          //       'Contact Number:',
          //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //     ),
          //   ],
          // ),
          // Text(
          //   user.contactNumber,
          //   style: TextStyle(fontSize: 16),
          // ),
          // additional donate button
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const OrganizationList(),
          //       ),
          //     );
          //   },
          //   child: Text('Donate'),
          // ),
        ],
      ),
    );
  }
}
