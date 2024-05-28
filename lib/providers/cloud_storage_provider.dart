import 'dart:io';

abstract class CloudStorageProvider {
  /// Uploads a [file] to cloud storage, returning the path to the uploaded
  /// file.
  Future<String> uploadFile(File file);

  Future<void> deleteFile(String cloudPath);

  /// Picks a file from cloud storage, downloads it to the app's internal
  /// storage, then returns the path to the downloaded file.
  ///
  /// The caller is responsible for deleting the downloaded file to reduce
  /// memory usage.
  Future<File> pickFile(String cloudPath);
}