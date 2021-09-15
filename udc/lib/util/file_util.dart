import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Storage {
  //获取原文件路径
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
      await customDirectory.create(recursive: true);
    }

    print("<><Storage._packageDirectory>file path: ${customDirectory.path}");
    return customDirectory.path;
  }

  //获取备份文件路径
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
      await customDirectory.create(recursive: true);
    }

    print("<><Storage._downloadDirectory>file path: ${customDirectory.path}");
    return customDirectory.path;
  }

  //获取原文件文件名
  Future<String> get _sourceFilePath async {
    final directory = await _packageDirectory;

    return '$directory/user_data_${DateTime.now().toString().substring(0, 10)}.csv';
  }

  //获取备份文件文件名
  Future<String> get _backupFilePath async {
    final directory = await _downloadDirectory;

    return "$directory/user_data_${DateTime.now().toString().substring(0, 19).replaceAll(' ', '_').replaceAll(':', '-')}.csv";
  }

  //读取文件
  Future<List<String>?> readData() async {
    try {
      var filePath = await _sourceFilePath;
      var file = File(filePath);

      if (await file.exists()) {
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

  //保存文件
  Future<File?> writeData(String data) async {
    try {
      var file = File(await _sourceFilePath);

      return file.writeAsString(data, flush: true);
    } catch (e) {
      print("<><Storage.writeData>error: $e");
      return null;
    }
  }

  //备份文件
  Future<File?> backupFile() async {
    try {
      await _deleteExpiredFiles();

      var sourceFile = File(await _sourceFilePath);
      var backupFile = await _backupFilePath;

      return sourceFile.copy("$backupFile");
    } catch (e) {
      print("<><Storage._backupFile>error: $e");
      return null;
    }
  }

  //删除当天过期文件
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
