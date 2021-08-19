import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Storage {
  Future<String> get _packageDirectory async {
    final Directory? packageDirectory = await getExternalStorageDirectory();
    final Directory? customDirectory =
        Directory("${packageDirectory!.parent.path}/UDC");

    if (await Permission.storage.request().isGranted) {
      //权限通过
      print("permission granted");
    }

    bool existed = await customDirectory!.exists();
    if (!existed) {
      await customDirectory.create();
    }

    print("<><Storage._packageDirectory>file path: ${customDirectory.path}");
    return customDirectory.path;
  }

  Future<String> get _downloadDirectory async {
    final Directory? packageDirectory = await getExternalStorageDirectory();
    final Directory? customDirectory = Directory(
        "${packageDirectory!.parent.parent.parent.parent.path}/Download/UDC");

    if (await Permission.storage.request().isGranted) {
      //权限通过
      print("permission granted");
    }

    bool existed = await customDirectory!.exists();
    if (!existed) {
      await customDirectory.create();
    }

    print("<><Storage._downloadDirectory>file path: ${customDirectory.path}");
    return customDirectory.path;
  }

  Future<File> get _sourceFile async {
    final directory = await _packageDirectory;

    return File(
        '$directory/user_data_${DateTime.now().toString().substring(0, 10)}.csv');
  }

  Future<File> get _backupFile async {
    final directory = await _downloadDirectory;

    return File(
        "$directory/user_data_${DateTime.now().toString().substring(0, 19).replaceAll(' ', '_').replaceAll(':', '-')}.csv");
  }

  Future<bool> fileExists() async {
    try {
      final file = await _sourceFile;
      return file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<List<String>?> readData() async {
    try {
      var file = await _sourceFile;
      var fileExists = await file.exists();

      if (fileExists) {
        var contents = await file.readAsLines();
        return contents;
      } else {
        return [];
      }
    } catch (e) {
      print("<><Storage.readData>error: $e");
      return null;
    }
  }

  Future<File?> writeData(String data) async {
    try {
      var sourceFile = await _sourceFile;

      await _deleteExpiredFiles();
      sourceFile.writeAsString(data, flush: true);
      var backupFile = await _backupFile;
      return sourceFile.copy("${backupFile.path}");
    } catch (e) {
      print("<><Storage.writeData>error: $e");
      return null;
    }
  }

  Future _deleteExpiredFiles() async {
    final directoryPath = await _downloadDirectory;
    Directory directory = Directory(directoryPath);

    String date = DateTime.now().toString().substring(0, 10);
    directory.list(recursive: true).forEach((element) {
      if (element.path.contains(date)) {
        element.delete();
      }
    });
  }
}
