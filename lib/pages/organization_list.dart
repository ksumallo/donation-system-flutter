import 'dart:collection';
import 'dart:math';

import 'package:final_proj/donate/donate_page.dart';
import 'package:final_proj/entities/organization.dart';
import 'package:final_proj/providers/organizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationList extends StatefulWidget {
  const OrganizationList({super.key});

  @override
  State<OrganizationList> createState() => _OrganizationListState();
}

class _OrganizationListState extends State<OrganizationList> {
  int _pageNumber = 0;
  int _pageSize = 10;

  Widget _getBottomNavigator(BuildContext context) {
    return FutureBuilder(
      future: context.read<Organizations>().getPageCount(_pageSize),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else {
          var navItems = <Widget>[
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: _pageNumber == 0 ? null : () {
                setState(() {
                  _pageNumber--;
                });
              },
            ),
          ];

          int pageNumber = min(max(0, _pageNumber), snapshot.data! - 1);

          for (int i = max(0, pageNumber - 2); i < min(pageNumber + 3, snapshot.data!); i++) {
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
            onPressed: _pageNumber == snapshot.data! - 1 ? null : () {
              setState(() {
                _pageNumber++;
              });
            },
          ));

          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: navItems
            )
          );
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organizations"),
      ),
      body: FutureBuilder<UnmodifiableListView<Organization>>(
          future: context
              .watch<Organizations>()
              .getOrganizations(_pageNumber, _pageSize),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: (snapshot.data![index].openForDonations
                            ? const Icon(Icons.check)
                            : const Icon(Icons.close)),
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(snapshot.data![index].description),
                        titleAlignment: ListTileTitleAlignment.center,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DonatePage(organization: snapshot.data![index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  _getBottomNavigator(context),
                ],
              );
            } 
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
