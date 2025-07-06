//handle the outputlist of label

import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/database/db.dart';
import 'package:englishvocabdatabase/database/label.dart';
import 'template.dart';
import 'package:flutter/foundation.dart';


class LabelListService{
  static Future<List<OutputListItem>> initLabelList() async{
    List<Label>? result = await DB.getAllLabels();//for test
    result ??= [];
    //避免nolabel顯示
    result.removeWhere((label) => label.name == 'nolabel');

    return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name);
  }

  static Future<List<OutputListItem>> searchLabel(String prefix) async{
    //for search in database
    List<Label>? result = await DB.searchLabel(prefix);  
    result ??= [];
    //避免nolabel顯示
    result.removeWhere((label) => label.name == 'nolabel');

    return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name);
  }

  static Future<(List<OutputListItem>?, int)> addLabel(String name) async{
    bool exist = await DB.hasLabel(label : name);

    if(exist){
      return (null, -1);
    }
    else{
      int success = await DB.addLabel(name).catchError((e){
        debugPrint('insertLabel error: $e');
      });

      if(success == -1){
        return (null, -1);
      }

      List<Label>? result = await DB.getAllLabels();//for test
      result ??= [];
      //避免nolabel顯示
      result.removeWhere((label) => label.name == 'nolabel');
      
      return (convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name), success);
    }
  }

  static Future<List<OutputListItem>?> deleteLabel(int id) async{
    bool exist = await DB.hasLabel(id: id);

    if(!exist){
      return null;
    }
    else{
      await DB.deleteLabel(id: id).catchError((e) {
        debugPrint('deleteLabel error: $e');
      });

      List<Label>? result = await DB.getAllLabels();
      result ??= [];
      //避免nolabel顯示
      result.removeWhere((label) => label.name == 'nolabel');
      
      return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name);
    }
  }
}