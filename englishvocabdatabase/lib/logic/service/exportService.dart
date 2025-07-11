import 'package:englishvocabdatabase/import_export/export.dart';
import 'package:englishvocabdatabase/database/label.dart';
import 'package:englishvocabdatabase/database/db.dart';
import 'package:englishvocabdatabase/database/word.dart';
import 'package:flutter/foundation.dart';

class ExportService{
  Future<void> exportByLabel(List<int> labels) async{
    List<Word>? words = await DB.getExportWords(labels);
    words ??= [];
    String csvString = await Export.listToCsv(words);

    await Export.writeCsvToDownloads(csvString);
    return;
  }
}