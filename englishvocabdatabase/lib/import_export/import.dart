import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import '../logic/service/wordService.dart';
import '../logic/service/nodefListService.dart';

Future<String?> pickAndUploadFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, 
      allowedExtensions: ['csv'], 
      allowMultiple: false, 
    );

    if (result != null) {
      PlatformFile platformFile = result.files.first;
      File selectedFile = File(platformFile.path!);
      return selectedFile.readAsString();
    }
    else{ //the user didn't choose a file
      return null;
    }
  } catch (e) {
    print('error: $e');
    return null;
  }
}

Future<List<List<dynamic>>> parseCsvString(String csvstring) async{
  final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvstring);
  return csvTable;
}

Future<List<int>> convertCsvToWords(List<List<dynamic>> csvlist) async{
  List<int> wordIds = [];

   if (csvlist.isEmpty) {
    return wordIds; //empty
  }
  final List<dynamic> headers = csvlist[0];
  Map<String, int> headerMap = {};
  for (int i = 0; i < headers.length; i++) {
    headerMap[headers[i].toString().trim().toLowerCase()] = i; 
  }
  final int? nameIndex = headerMap['name'];
  final int? definitionIndex = headerMap['definition'];
  final int? chineseIndex = headerMap['chinese'];

  if(nameIndex == null){
    return [];
  }
  
  final List<List<dynamic>> dataRows = csvlist.sublist(1);
  for(var row in dataRows){
     var name = row[nameIndex].toString();
    if (name.trim().isEmpty){
      continue;
    }

    String? definition;
    String? chinese;

    if(definitionIndex != null){
      definition = row[definitionIndex]?.toString();
    }
    if(chineseIndex != null){
      chinese = row[chineseIndex]?.toString();
    }
    if (definition != null && definition.trim().isNotEmpty) {
      final wordId = await WordListService.addWord(name, definition: definition, chinese: chinese);
      wordIds.add(wordId);
    } else {
      await NodefListService.addNoDef(name);
    }
  }

  return wordIds;
}