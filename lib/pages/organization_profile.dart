import 'dart:developer';

import 'package:final_proj/entities/organization.dart';
import 'package:final_proj/entities/user.dart';
import 'package:final_proj/pages/organization_list.dart';
import 'package:final_proj/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/profile_info_tile.dart';

class OrganizationProfile extends StatelessWidget {
  final Organization org;

  const OrganizationProfile({super.key, required this.org});

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
                  const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                          Icons.account_circle,
                          size: 72)
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        org.name,
                        style: TextStyle(
                            fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                            fontWeight: FontWeight.bold),
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
              ProfileInfoTile(label: "Description", value: org.description)
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
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Existing content
  //         Card.outlined(
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               children: [
  //                 const Icon(Icons.account_circle, size: 56),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       org.name,
  //                       style: TextStyle(
  //                           fontSize:
  //                               Theme.of(context).textTheme.bodyLarge!.fontSize,
  //                           fontWeight: FontWeight.bold),
  //                     )
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         const Chip(
  //           avatar: Icon(Icons.home),
  //           label: Text('Addresses:'),
  //         ),
  //         const Row(
  //           children: [
  //             Icon(Icons.phone, size: 24),
  //             SizedBox(width: 8),
  //             Text(
  //               'Contact Number:',
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //             ),
  //           ],
  //         ),
  //         // additional donate button
  //         Expanded(
  //           child: ElevatedButton(
  //             onPressed: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const OrganizationList(),
  //                 ),
  //               );
  //             },
  //             child: Text('Get verified'),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
