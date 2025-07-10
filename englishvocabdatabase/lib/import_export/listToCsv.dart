import 'package:csv/csv.dart';
import '../database/word.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

  static Future<String> writeCsvToFile(String csvString) async {
    // 取得文件目錄（app文件資料夾）
    final directory = await getApplicationDocumentsDirectory();
    
    // 設定完整路徑
    final fileName = await _getNextExportFileName();
    final path = '${directory.path}/$fileName';

    // 建立檔案
    final file = File(path);

    // 將字串寫入檔案（覆蓋）
    await file.writeAsString(csvString);

    return path; // 回傳檔案路徑
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