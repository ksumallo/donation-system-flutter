import 'package:final_proj/entities/user.dart';
import 'package:flutter/foundation.dart';

abstract class AuthProvider with ChangeNotifier {
  @protected
  Future<User> loginINTERNAL(String email, String password);

  @protected
  Future<void> logoutINTERNAL();

  @protected
  Future<void> registerINTERNAL(String email, String password, String name, String username, List<String> addresses, String contactNumber);

  @protected
  Future<User?> getCurrentUserINTERNAL();

  @protected
  Stream<User?> getAuthStateChangesINTERNAL();

  Future<User> login(String email, String password) async {
    User user = await loginINTERNAL(email, password);
    notifyListeners();
    return user;
  }

  Future<void> logout() async {
    await logoutINTERNAL();
    notifyListeners();
  }

  Future<void> register(String email, String password, String name, String username, List<String> addresses, String contactNumber) async {
    await registerINTERNAL(email, password, name, username, addresses, contactNumber);
    notifyListeners();
  }

  Future<User?> get currentUser async => await getCurrentUserINTERNAL();

  Stream<User?> get authStateChanges async* {
    yield* getAuthStateChangesINTERNAL();
  }
}