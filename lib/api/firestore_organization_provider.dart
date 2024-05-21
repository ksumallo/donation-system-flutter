import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/entities/organization.dart';
import 'package:final_proj/entities/user.dart';
import 'package:final_proj/providers/organizations.dart';
import 'package:final_proj/providers/user_provider.dart';

class _OrganizationDAO {
  final String name;
  final String description;
  final bool openForDonations;
  final List<String> userIds;

  _OrganizationDAO({
    required this.name,
    required this.description,
    required this.openForDonations,
    required this.userIds,
  });

  factory _OrganizationDAO.fromMap(Map<String, dynamic> data) {
    return _OrganizationDAO(
      name: data['name'] as String,
      description: data['description'] as String,
      openForDonations: data['openForDonations'] as bool,
      userIds: data['users'] as List<String>,
    );
  }

  factory _OrganizationDAO.fromOrganization(Organization organization) {
    return _OrganizationDAO(
      name: organization.name,
      description: organization.description,
      openForDonations: organization.openForDonations,
      userIds: organization.users.map((user) => user.uid).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'openForDonations': openForDonations,
      'users': userIds,
    };
  }

  Future<Organization> toOrganization(
      String id, UserProvider userProvider) async {
    List<Future<User>> futures = [];
    for (var userId in userIds) {
      futures.add(userProvider.getUserById(userId));
    }

    List<User> users = await Future.wait(futures);

    return Organization(
      id: id,
      name: name,
      description: description,
      openForDonations: openForDonations,
      users: users,
    );
  }
}

class FirestoreOrganizationProvider extends OrganizationProvider {
  final FirebaseFirestore _db;
  final UserProvider _userProvider;

  FirestoreOrganizationProvider(this._db, {required UserProvider userProvider})
      : _userProvider = userProvider;

  @override
  Future<void> addINTERNAL(Organization organization) async {
    final data = _OrganizationDAO.fromOrganization(organization).toMap();
    final organizations = _db.collection("organizations");
    await organizations.doc(organization.id).set(data);
  }

  @override
  Future<void> removeINTERNAL(Organization organization) async {
    final organizations = _db.collection("organizations");
    await organizations.doc(organization.id).delete();
  }

  @override
  Future<void> updateINTERNAL(Organization organization) async {
    final data = _OrganizationDAO.fromOrganization(organization).toMap();
    final organizations = _db.collection("organizations");
    await organizations.doc(organization.id).update(data);
  }

  @override
  Future<List<Organization>> getAllINTERNAL() async {
    final organizations = _db.collection("organizations");
    final snapshot = await organizations.get();

    List<Organization> organizationsList = [];
    for (var doc in snapshot.docs) {
      organizationsList.add(
        await _OrganizationDAO.fromMap(doc.data()).toOrganization(doc.id, _userProvider),
      );
    }

    return organizationsList;
  }

  @override
  Future<Organization> getByIdINTERNAL(String id) async {
    final organizations = _db.collection("organizations");
    final snapshot = await organizations.doc(id).get();

    if (!snapshot.exists) {
      throw Exception("Organization does not exist");
    }

    return _OrganizationDAO.fromMap(snapshot.data()!).toOrganization(id, _userProvider);
  }
}
