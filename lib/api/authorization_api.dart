import 'package:final_proj/api/user_repository.dart';
import 'package:final_proj/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthApi {
  final fb_auth.FirebaseAuth _auth;
  final UserRepository _userRepository;

  FirebaseAuthApi(FirebaseApp app, this._userRepository)
      : _auth = fb_auth.FirebaseAuth.instanceFor(app: app);

  Stream<User?> get authStateChanges async* {
    Stream<fb_auth.User?> stream = _auth.authStateChanges();

    await for (fb_auth.User? user in stream) {
      if (user == null) {
        yield null;
      } else {
        yield await _userRepository.getUser(user.uid);
      }
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
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

    User user = await _userRepository.getUser(uid);
    return user;
  }

  Future<void> signOut() {
    return _auth.signOut();
  }
}
