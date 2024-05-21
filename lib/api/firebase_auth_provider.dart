import 'package:final_proj/entities/user.dart';
import 'package:final_proj/providers/auth_provider.dart';
import 'package:final_proj/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

class FirebaseAuthProvider extends AuthProvider {
  final fb_auth.FirebaseAuth _auth;
  final UserProvider _userProvider;

  FirebaseAuthProvider(this._auth, this._userProvider);

  @override
  Stream<User?> getAuthStateChangesINTERNAL() async* {
    Stream<fb_auth.User?> stream = _auth.authStateChanges();

    await for (fb_auth.User? user in stream) {
      if (user == null) {
        yield null;
      } else {
        yield await _userProvider.getUserById(user.uid);
      }
    }
  }

  @override
  Future<User?> getCurrentUserINTERNAL() async {
    return _auth.currentUser == null ? null : await _userProvider.getUserById(_auth.currentUser!.uid);
  }

  @override
  Future<User> loginINTERNAL(String email, String password) async {
    if (_auth.currentUser != null) {
      throw Exception("User already signed in");
    }

    fb_auth.UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user?.uid;
    if (uid == null) {
      throw Exception("Failed to sign in");
    }

    User user = await _userProvider.getUserById(uid);
    return user;
  }

  @override
  Future<void> logoutINTERNAL() {
    return _auth.signOut();
  }

  @override
  Future<void> registerINTERNAL(String email, String password, String name, String username, List<String> addresses, String contactNumber) async {
    if (_auth.currentUser != null) {
      throw Exception("User already signed in");
    }

    fb_auth.UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user?.uid;
    if (uid == null) {
      throw Exception("Failed to sign in");
    }

    User user = User(
      uid: uid,
      name: name,
      username: username,
      addresses: addresses,
      contactNumber: contactNumber,
    );

    await _userProvider.createUser(user);
  }
}
