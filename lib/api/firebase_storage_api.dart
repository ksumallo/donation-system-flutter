import 'dart:io';

import 'package:final_proj/providers/cloud_storage_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseStorageProvider extends CloudStorageProvider {
  final FirebaseStorage _storage;

  FirebaseStorageProvider(this._storage);

  @override
  Future<String> uploadFile(File file, String path) async {
    return await _storage
        .ref()
        .child(path)
        .putFile(File(file.path))
        .then((task) => task.ref.fullPath);
  }

  @override
  Future<File> pickFile(String cloudPath) async {
    final ref = _storage
      .ref(cloudPath);

    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.absolute.path}/${ref.name}");

    if (await file.exists()) {
      return file;
    }

    await ref.writeToFile(file);
    return file;
  }

  @override
  Future<void> deleteFile(String cloudPath) async {
    await _storage
      .ref(cloudPath)
      .delete();
  }
}