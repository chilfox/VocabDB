import 'package:csv/csv.dart';
import '../database/word.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Export{
  static Future<String> listToCsv(List<Word> wordlist) async{
    List<List<dynamic>> csvData = [];
    csvData.add(['id', 'name', 'definition', 'parts of speech', 'chinese', 'sentence']);
    for (var word in wordlist) {
      csvData.add([
        word.id,
        word.name,
        word.definition,
        word.parts,
        word.chinese,
        word.sentence,
      ]);
    }
    final String csvString = const ListToCsvConverter().convert(csvData);
    return csvString;
  }

  static Future<bool> writeCsvToDownloads(String csvString) async {
    String filename = await _getNextExportFileName();
    bool success = await _MediaStoreHelper.saveCsvToDownloads(filename, csvString);
    if (success) {
      debugPrint('CSV saved to Downloads!');
    } else {
      debugPrint('Failed to save CSV.');
    }
    return success;
  }

  static Future<String> _getNextExportFileName() async {
    final directory = await getApplicationDocumentsDirectory();

    // 讀出目錄裡所有檔案
    final files = directory.listSync();

    // 過濾出檔名符合 export{number}.csv 的檔案
    final regex = RegExp(r'export(\d+)\.csv');

    int maxNumber = 0;

    for (var file in files) {
      if (file is File) {
        final name = file.path.split('/').last;
        final match = regex.firstMatch(name);
        if (match != null) {
          int number = int.parse(match.group(1)!);
          if (number > maxNumber) maxNumber = number;
        }
      }
    }

    int nextNumber = maxNumber + 1;
    return 'export$nextNumber.csv';
  }
}

class _MediaStoreHelper {
  static const MethodChannel _channel = MethodChannel('media_store');

  static Future<bool> saveCsvToDownloads(String fileName, String csvContent) async {
    try {
      final bool result = await _channel.invokeMethod('saveCsv', {
        'fileName': fileName,
        'csvContent': csvContent,
      });
      return result;
    } catch (e) {
      debugPrint('Error saving CSV: $e');
      return false;
    }
  }
}