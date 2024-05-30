import 'dart:collection';
import 'dart:math';

import 'package:final_proj/entities/donation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/organization_list_item.dart';
import '../entities/organization.dart';
import '../providers/organizations.dart';

class DonationsList extends StatefulWidget {
  @override
  createState() => _DonationsListState();
}

class _DonationsListState extends State<DonationsList> {
  int _pageNumber = 0;
  int _pageSize = 10;

  Widget _getBottomNavigator(BuildContext context) {
    return FutureBuilder(
        future: context.read<OrganizationProvider>().getPageCount(_pageSize),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var navItems = <Widget>[
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: _pageNumber == 0
                    ? null
                    : () {
                        setState(() {
                          _pageNumber--;
                        });
                      },
              ),
            ];

            int pageNumber = min(max(0, _pageNumber), snapshot.data! - 1);

            for (int i = max(0, pageNumber - 2);
                i < min(pageNumber + 3, snapshot.data!);
                i++) {
              navItems.add(TextButton(
                child: Text((i + 1).toString()),
                onPressed: () {
                  setState(() {
                    _pageNumber = i;
                  });
                },
              ));
            }

            navItems.add(IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: _pageNumber == snapshot.data! - 1
                  ? null
                  : () {
                      setState(() {
                        _pageNumber++;
                      });
                    },
            ));

            return Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: navItems));
          }
        });
  }

  List<String> dummyDonations = [
    'Donation 1',
    'Donation 2',
    'Donation 3',
    'Donation 4',
    'Donation 5',
    'Donation 6',
    'Donation 7',
    'Donation 8',
    'Donation 9',
    'Donation 10',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UnmodifiableListView<Organization>>(
      future:
          context.watch<OrganizationProvider>().getPage(_pageNumber, _pageSize),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dummyDonations[index]),
                    subtitle: Text(DateTime.now().toString()),
                    onTap: () {},
                  );
                },
              ),
              _getBottomNavigator(context),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
