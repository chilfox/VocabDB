import 'package:csv/csv.dart';
import '../database/word.dart';

Future<String> listToCsv(List<Word> wordlist) async{
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