import 'dart:collection';

import 'package:final_proj/entities/organization.dart';
import 'package:flutter/material.dart';

/// Provides access to a collection of [Organization]s that can be updated.
abstract class Organizations with ChangeNotifier {
  /// Returns the number of pages of organizations in the collection if each page contained
  /// [pageSize] organizations.
  Future<int> getPageCount(int pageSize);

  /// Returns the organizations on page [pageNumber] of the collection if each page contained
  /// [pageSize] organizations.
  Future<UnmodifiableListView<Organization>> getOrganizations(
    int pageNumber,
    int pageSize,
  );

  /// Adds [organization] to the collection.
  Future<void> add(Organization organization);

  /// Removes [organization] from the list.
  Future<void> remove(Organization organization);

  /// Updates [organization] in the list. An organization with the same ID as [organization] must
  /// exist in the collection for it to be updated. Otherwise, the collection will be unchanged.
  Future<void> update(Organization organization);
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
  Future<int> getPageCount(int pageSize) {
    return Future.value((_organizations.length / pageSize).ceil());
  }

  @override
  Future<UnmodifiableListView<Organization>> getOrganizations(
    int pageNumber,
    int pageSize,
  ) {
    return Future.sync(() {
      int start = (pageNumber - 1) * pageSize;
      int end = start + pageSize;

      if (start >= _organizations.length) {
        return UnmodifiableListView<Organization>([]);
      } else if (end > _organizations.length) {
        return UnmodifiableListView(_organizations.skip(start));
      } else {
        return UnmodifiableListView(_organizations.getRange(start, end));
      }
    });
  }

  @override
  Future<void> add(Organization organization) {
    return Future.sync(() {
      _organizations.add(organization);
      notifyListeners();
    });
  }

  @override
  Future<void> remove(Organization organization) {
    return Future.sync(() {
      _organizations.remove(organization);
      notifyListeners();
    });
  }

  @override
  Future<void> update(Organization organization) {
    return Future.sync(() {
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
    });
  }
}
