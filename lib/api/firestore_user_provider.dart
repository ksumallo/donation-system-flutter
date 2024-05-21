import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/entities/user.dart';
import 'package:final_proj/providers/user_provider.dart';

class _UserDAO {
  final String name;
  final String username;
  final List<String> addresses;
  final String contactNumber;

  _UserDAO({
    required this.name,
    required this.username,
    required this.addresses,
    required this.contactNumber,
  });

  factory _UserDAO.fromMap(Map<String, dynamic> map) {
    return _UserDAO(
      name: map['name'] as String,
      username: map['username'] as String,
      addresses: (map['addresses'] as List).cast<String>(),
      contactNumber: map['contact_number'] as String,
    );
  }

  factory _UserDAO.fromUser(User user) {
    return _UserDAO(
      name: user.name,
      username: user.username,
      addresses: user.addresses,
      contactNumber: user.contactNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'addresses': addresses,
      'contact_number': contactNumber,
    };
  }

  User toUser(String uid) {
    return User(
      uid: uid,
      name: name,
      username: username,
      addresses: addresses,
      contactNumber: contactNumber,
    );
  }
}

class FirestoreUserProvider extends UserProvider {
  final FirebaseFirestore _db;

  FirestoreUserProvider(this._db);

  @override
  Future<void> createUserINTERNAL(User user) async {
    final data = _UserDAO.fromUser(user).toMap();
    final users = _db.collection("users");

    if ((await users.doc(user.uid).get()).exists) {
      throw Exception("User already exists");
    }

    await users.doc(user.uid).set(data);
  }

  @override
  Future<List<User>> getUsersINTERNAL() async {
    final users = _db.collection("users");
    final snapshot = await users.get();
    return snapshot.docs
        .map((doc) => _UserDAO.fromMap(doc.data()).toUser(doc.id))
        .toList();
  }

  @override
  Future<User> getUserByIdINTERNAL(String id) async {
    final users = _db.collection("users");
    final snapshot = await users.doc(id).get();

    if (!snapshot.exists) {
      throw Exception("User does not exist");
    }

    final data = snapshot.data();
    return _UserDAO.fromMap(data!).toUser(id);
  }

  @override
  Future<void> updateUserINTERNAL(User user) async {
    final data = _UserDAO.fromUser(user).toMap();
    final users = _db.collection("users");
    await users.doc(user.uid).update(data);
  }

  @override
  Future<void> deleteUserINTERNAL(User user) async {
    final users = _db.collection("users");
    await users.doc(user.uid).delete();
  }
}
