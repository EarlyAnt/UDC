import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    final _directory = await getExternalStorageDirectory();
    return _directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File(
        '$path/user_data_${DateTime.now().toString().substring(0, 10)}.txt');
  }

  Future<bool> fileExists() async {
    try {
      final file = await _localFile;
      return file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      var contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(counter) async {
    final file = await _localFile;

    return file.writeAsString('$counter');
  }

  Future<List<String>> readData() async {
    try {
      var file = await _localFile;
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

  Future<File> writeData(data) async {
    try {
      var file = await _localFile;
      var fileExists = await file.exists();

      if (fileExists) {
        return file.writeAsString('$data');
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
