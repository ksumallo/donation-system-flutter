import 'dart:collection';

import 'package:final_proj/entities/organization.dart';
import 'package:flutter/material.dart';

/// Provides access to a collection of [Organization]s that can be updated.

class OrganizationProvider with ChangeNotifier {
  Future<void> addINTERNAL(Organization organization) {
    throw UnimplementedError();
  }

  Future<void> removeINTERNAL(Organization organization) {
    throw UnimplementedError();
  }

  Future<void> updateINTERNAL(Organization organization) {
    throw UnimplementedError();
  }

  Future<List<Organization>> getAllINTERNAL() {
    throw UnimplementedError();
  }

  Future<Organization> getByIdINTERNAL(String id) {
    throw UnimplementedError();
  }

  OrganizationProvider();

  /// Returns the number of pages of organizations in the collection if each page contained
  /// [pageSize] organizations.
  Future<int> getPageCount(int pageSize) async {
    List<Organization> organizations = await getAllINTERNAL();

    return (organizations.length / pageSize).ceil();
  }

  /// Returns the organizations on page [pageNumber] of the collection if each page contained
  /// [pageSize] organizations.
  Future<UnmodifiableListView<Organization>> getPage(
    int pageNumber,
    int pageSize,
  ) async {
    List<Organization> organizations = await getAllINTERNAL();

    int startIndex = (pageNumber - 1) * pageSize;
    return UnmodifiableListView(
        organizations.getRange(startIndex, startIndex + pageSize));
  }

  /// Adds [organization] to the collection.
  Future<void> add(Organization organization) async {
    await addINTERNAL(organization);
    notifyListeners();
  }

  /// Removes [organization] from the list.
  Future<void> remove(Organization organization) async {
    await removeINTERNAL(organization);
    notifyListeners();
  }

  /// Updates [organization] in the list. An organization with the same ID as [organization] must
  /// exist in the collection for it to be updated. Otherwise, the collection will be unchanged.
  Future<void> update(Organization organization) async {
    await updateINTERNAL(organization);
    notifyListeners();
  }
}

// final class ListOrganizations extends OrganizationProvider {
//   final List<Organization> _organizations = [
//     Organization(
//       id: "test-1",
//       name: "Test Organization 1",
//       openForDonations: true,
//     ),
//     Organization(
//       id: "test-2",
//       name: "Test Organization 2",
//       openForDonations: false,
//     ),
//     Organization(
//       id: "test-3",
//       name: "Test Organization 3",
//       openForDonations: true
//     ),
//     Organization(
//       id: "test-4",
//       name: "Test Organization 4",
//       openForDonations: true,
//     ),
//     Organization(
//       id: "test-5",
//       name: "Test Organization 5",
//       openForDonations: false,
//     ),
//     Organization(
//       id: "test-6",
//       name: "Test Organization 6",
//       openForDonations: true,
//     ),
//     Organization(
//       id: "test-7",
//       name: "Test Organization 7",
//       openForDonations: false,
//     ),
//     Organization(
//       id: "test-8",
//       name: "Test Organization 8",
//       openForDonations: true,
//     ),
//     Organization(
//       id: "test-9",
//       name: "Test Organization 9",
//       openForDonations: false,
//     ),
//     Organization(
//       id: "test-10",
//       name: "Test Organization 10",
//       openForDonations: true,
//     ),
//     Organization(
//       id: "test-11",
//       name: "Test Organization 11",
//       openForDonations: false,
//     ),
//     Organization(
//       id: "test-12",
//       name: "Test Organization 12",
//       openForDonations: true,
//     ),
//     Organization(
//       id: "test-13",
//       name: "Test Organization 13",
//       openForDonations: false,
//     ),
//     Organization(
//       id: "test-14",
//       name: "Test Organization 14",
//       openForDonations: true,
//     ),
//     Organization(
//       id: "test-15",
//       name: "Test Organization 15",
//       openForDonations: false,
//     ),
//     Organization(
//       id: "test-16",
//       name: "Test Organization 16",
//       openForDonations: true,
//     ),
//     Organization(
//       id: "test-17",
//       name: "Test Organization 17",
//       openForDonations: false,
//     ),
//     Organization(
//       id: "test-18",
//       name: "Test Organization 18",
//       openForDonations: true,
//     ),
//     Organization(
//       id: "test-19",
//       name: "Test Organization 19",
//       openForDonations: false,
//     ),
//     Organization(
//       id: "test-20",
//       name: "Test Organization 20",
//       openForDonations: true,
//     ),
//   ];

//   @override
//   Future<int> getPageCount(int pageSize) {
//     return Future.value((_organizations.length / pageSize).ceil());
//   }

//   @override
//   Future<UnmodifiableListView<Organization>> getOrganizations(
//     int pageNumber,
//     int pageSize,
//   ) {
//     return Future.sync(() {
//       int start = pageNumber * pageSize;
//       int end = start + pageSize;

//       if (start >= _organizations.length) {
//         return UnmodifiableListView<Organization>([]);
//       } else if (end >= _organizations.length) {
//         return UnmodifiableListView(_organizations.skip(start));
//       } else {
//         return UnmodifiableListView(_organizations.getRange(start, end));
//       }
//     });
//   }

//   @override
//   Future<void> add(Organization organization) {
//     return Future.sync(() {
//       _organizations.add(organization);
//       notifyListeners();
//     });
//   }

//   @override
//   Future<void> remove(Organization organization) {
//     return Future.sync(() {
//       _organizations.remove(organization);
//       notifyListeners();
//     });
//   }

//   @override
//   Future<void> update(Organization organization) {
//     return Future.sync(() {
//       for (var org in _organizations) {
//         if (org.id == organization.id) {
//           org.name = organization.name;
//           org.description = organization.description;
//           org.openForDonations = organization.openForDonations;
//           org.donations.clear();
//           org.donations.addAll(organization.donations);
//           break;
//         }
//       }

//       notifyListeners();
//     });
//   }
// }
