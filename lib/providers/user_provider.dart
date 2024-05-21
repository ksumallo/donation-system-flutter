import 'package:final_proj/entities/user.dart';
import 'package:flutter/foundation.dart';

abstract class UserProvider with ChangeNotifier {
  @protected
  Future<void> createUserINTERNAL(User user);

  @protected
  Future<void> updateUserINTERNAL(User user);

  @protected
  Future<void> deleteUserINTERNAL(User user);

  @protected
  Future<List<User>> getUsersINTERNAL();

  @protected
  Future<User> getUserByIdINTERNAL(String id);

  Future<void> createUser(User user) async {
    await createUserINTERNAL(user);
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    await updateUserINTERNAL(user);
    notifyListeners();
  }

  Future<void> deleteUser(User user) async {
    await deleteUserINTERNAL(user);
    notifyListeners();
  }

  Future<List<User>> getUsers() async {
    return await getUsersINTERNAL();
  }

  Future<User> getUserById(String id) async {
    return await getUserByIdINTERNAL(id);
  }
}