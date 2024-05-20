import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/entities/user.dart';

abstract class UserRepository {
  Future<void> createUser(User user);

  Future<List<User>> getUsers();

  Future<User> getUser(String username);

  Future<void> updateUser(User user);

  Future<void> deleteUser(String username);
}

class FirestoreUserRepository implements UserRepository {
  final FirebaseFirestore _db;

  const FirestoreUserRepository(this._db);

  @override
  Future<void> createUser(User user) async {
    final data = <String, dynamic>{}
      ..update(
        "name",
        (value) => user.name,
        ifAbsent: () => user.name,
      )
      ..update(
        "username",
        (value) => user.username,
        ifAbsent: () => user.username,
      )
      ..update(
        "addresses",
        (value) => user.addresses,
        ifAbsent: () => user.addresses,
      )
      ..update(
        "contact_number",
        (value) => user.contactNumber,
        ifAbsent: () => user.contactNumber,
      )
      ..update(
        "donations",
        (value) => [],
        ifAbsent: () => [],
      ) // Cannot provide yet as donations has no definition
      ..update(
        "organizations",
        (value) => user.organizations.map((org) => org.id),
        ifAbsent: () => user.organizations.map((org) => org.id),
      );

    final users = _db.collection("users");
    if ((await users.get())
        .docs
        .any((element) => element.data()["username"] == user.username)) {
      throw Exception("User already exists");
    }

    await users.doc(user.uid).set(data);
  }

  @override
  Future<List<User>> getUsers() async {
    final users = _db.collection("users");

    final snapshot = await users.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return User(
        uid: doc.id,
        name: data["name"] as String,
        username: data["username"] as String,
        addresses: data["addresses"] as List<String>,
        contactNumber: data["contact_number"] as String,
        donations: [],
        organizations: [],
      );
    }).toList();
  }

  @override
  Future<User> getUser(String uid) async {
    final users = _db.collection("users");
    final snapshot = await users.get().then((docs) {
      return docs.docs.firstWhere((element) => element.id == uid);
    });

    if (!snapshot.exists) {
      throw Exception("User does not exist");
    }

    final data = snapshot.data();
    return User(
      uid: snapshot.id,
      name: data["name"] as String,
      username: data["username"] as String,
      addresses: data["addresses"] as List<String>,
      contactNumber: data["contact_number"] as String,
      donations: [],
      organizations: [],
    );
  }

  @override
  Future<void> updateUser(User user) async {
    final users = _db.collection("users");
    final snapshot = users.doc(user.uid);

    if (!(await snapshot.get()).exists) {
      throw Exception("User does not exist");
    }

    await snapshot.update({
      "name": user.name,
      "addresses": user.addresses,
      "contact_number": user.contactNumber,
      "organizations": user.organizations.map((org) => org.id),
    });
  }

  @override
  Future<void> deleteUser(String username) async {
    final users = _db.collection("users");
    await users.doc(username).delete();
  }
}
