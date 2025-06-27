//handle the outputlist of nodef

import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/database/db.dart';
import 'package:englishvocabdatabase/database/nodef.dart';
import 'template.dart';

class NodefListService{
  static Future<List<OutputListItem>> initNoDefList() async{
    List<NoDefinition>? result = await DB.getAllNoDefs();//for test
    result ??= [];
    return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name);
  }

  static Future<List<OutputListItem>> searchNoDef(String prefix) async{
    //for search in database
    List<NoDefinition>? result = await DB.searchNoDef(prefix);   
    result ??= [];
    return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name);
  }

  static Future<(List<OutputListItem>?, int)> addNoDef(String name) async{
    int success = await DB.addNoDef(name).catchError((e){
      print('insertNodef error: $e');  //for test
    });

    if(success == -1){
      return (null, -1);
    }

    List<NoDefinition>? result = await DB.getAllNoDefs();//for test
    result ??= [];
    return (convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name), success);
  }

  static Future<List<OutputListItem>?> deleteNoDef(int id) async{
    bool exist = await DB.hasNoDef(id);

    if(!exist){
      return null;
    }
    else{
      await DB.deleteNoDef(id).catchError((e) {
        print('delete Nodef error: $e');   //for test
      });

      List<NoDefinition>? result = await DB.getAllNoDefs();//for test
      result ??= [];
      return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name);
    }
  }
}