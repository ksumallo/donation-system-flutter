import 'dart:collection';

import 'package:final_proj/entities/organization.dart';
import 'package:flutter/material.dart';

abstract class Organizations with ChangeNotifier {
  /// Returns the number of pages of organizations in the list if each page contained [pageSize] organizations
  int getPageCount(int pageSize);

  UnmodifiableListView<Organization> getOrganizations(
    int pageNumber,
    int pageSize,
  );

  void add(Organization organization);

  void remove(Organization organization);

  void update(Organization organization);
}

final class ListOrganizations extends Organizations {
  final List<Organization> _organizations = [
    Organization(
      id: "test-1",
      name: "Test Organization 1",
      description: "Sample Text",
      openForDonations: true,
    ),
    Organization(
      id: "test-2",
      name: "Test Organization 2",
      description: "Sample Text",
      openForDonations: false,
    ),
  ];

  @override
  int getPageCount(int pageSize) {
    return (_organizations.length / pageSize).ceil();
  }

  @override
  UnmodifiableListView<Organization> getOrganizations(
    int pageNumber,
    int pageSize,
  ) {
    return UnmodifiableListView<Organization>(
      _organizations
          .getRange((pageNumber - 1) * pageSize, pageNumber * pageSize),
    );
  }

  @override
  void add(Organization organization) {
    _organizations.add(organization);
    notifyListeners();
  }

  @override
  void remove(Organization organization) {
    _organizations.remove(organization);
    notifyListeners();
  }

  @override
  void update(Organization organization) {
    for (var org in _organizations) {
      if (org.id == organization.id) {
        org.name = organization.name;
        org.description = organization.description;
        org.openForDonations = organization.openForDonations;
        org.donations.clear();
        org.donations.addAll(organization.donations);
        break;
      }
    }

    notifyListeners();
  }
}
