import 'package:englishvocabdatabase/import_export/listToCsv.dart';
import 'package:englishvocabdatabase/database/label.dart';
import 'package:englishvocabdatabase/database/db.dart';
import 'package:englishvocabdatabase/database/word.dart';
import 'package:flutter/foundation.dart';

class ExportService{
  Future<void> exportByLabel(List<int> labels) async{
    List<Word>? words = await DB.getExportWords(labels);
    words ??= [];
    String csvString = await Export.listToCsv(words);

    String filePath = await Export.writeCsvToFile(csvString);

    debugPrint('CSV saved at $filePath');

    return;
  }
}