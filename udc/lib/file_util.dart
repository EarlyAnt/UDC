import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

class Storage {
  Future printDirectories() async {
    Directory? directory;
    directory = await getApplicationDocumentsDirectory();
    print("getApplicationDocumentsDirectory: ${directory.path}");
    directory = await getApplicationSupportDirectory();
    print("getApplicationSupportDirectory: ${directory.path}");
    // path = await getDownloadsDirectory();
    // print("getDownloadsDirectory: ${path.path}");
    directory = await getTemporaryDirectory();
    print("getTemporaryDirectory: ${directory.path}");
    directory = await getExternalStorageDirectory();
    print("getExternalStorageDirectory: ${directory?.path}");
    // path = await getLibraryDirectory();
    // print("getLibraryDirectory: ${path.path}");
    directory = await getTemporaryDirectory();
    print("getTemporaryDirectory: ${directory.path}");

    List<Directory>? directories = await getExternalStorageDirectories();
    for (var dir in directories!) {
      print("ExternalStorageDirectories: ${dir.path}\n");
    }
  }

  // Future requestPermissions() async {
  //   Permission permission = Permission.storage;
  //   //权限的状态
  //   PermissionStatus status = await permission.status;

  //   if (status.isUndetermined) {
  //     //从未申请过
  //     permission.request();
  //   } else if (status.isDenied) {
  //     //第一次申请用户拒绝
  //     permission.request();
  //   } else if (status.isPermanentlyDenied) {
  //     //用户点击了 拒绝且不再提示
  //     permission.request();
  //   } else {
  //     //权限通过
  //     print("permission granted");
  //   }
  // }

  Future<String> get localPath async {
    final Directory? packageDirectory = await getExternalStorageDirectory();
    final Directory? customDirectory = Directory("${packageDirectory?.path}");

    bool? existed = await customDirectory?.exists();
    if (!existed!) {
      // await requestPermissions();
      await customDirectory?.create();
    }

    print("<><Storage._localPath>file path: ${customDirectory?.path}");
    return customDirectory!.path;
  }

  Future<String> get localFilePath async {
    final path = await localPath;

    return '$path/user_data_${DateTime.now().toString().substring(0, 10)}.csv';
  }

  Future<File> get localFile async {
    final path = await localPath;

    return File(
        '$path/user_data_${DateTime.now().toString().substring(0, 10)}.csv');
  }

  Future<bool> fileExists() async {
    try {
      final file = await localFile;
      return file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<int> readCounter() async {
    try {
      final file = await localFile;

      var contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(counter) async {
    final file = await localFile;

    return file.writeAsString('$counter');
  }

  Future<List<String>?> readData() async {
    try {
      var file = await localFile;
      var fileExists = await file.exists();

      if (fileExists) {
        var contents = await file.readAsLines();
        return contents;
      } else {
        return [];
      }
    } catch (e) {
      return null;
    }
  }

  Future<File?> writeData(String data) async {
    try {
      var file = await localFile;
      var fileExistes = await file.exists();

      if (!fileExistes) {
        file.writeAsBytes([0xEF, 0xBB, 0xBF]);
      }

      return file.writeAsString(data);
    } catch (e) {
      return null;
    }
  }
}
