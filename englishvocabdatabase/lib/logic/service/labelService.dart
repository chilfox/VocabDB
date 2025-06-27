//handle the outputlist of label

import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/database/db.dart';
import 'package:englishvocabdatabase/database/label.dart';
import 'template.dart';

class LabelListService{
  Future<List<OutputListItem>> initLabelList() async{
    List<Label>? result = await DB.getAllLabels();//for test
    result ??= [];

    return convertToOutputList(result, (l) => l.id, (l) => l.name);
  }

  Future<List<OutputListItem>> searchLabel(String prefix) async{
    //for search in database
    List<Label>? result = await DB.searchLabel(prefix);  
    result ??= [];
    return convertToOutputList(result, (l) => l.id, (l) => l.name); 
  }

  Future<(List<OutputListItem>?, int)> addLabel(String name) async{
    bool exist = await DB.hasLabel(label : name);

    if(exist){
      return (null, -1);
    }
    else{
      int success = await DB.addLabel(name).catchError((e){
        print('insertLabel error: $e');  //for test
      });

      if(success == -1){
        return (null, -1);
      }

      List<Label>? result = await DB.getAllLabels();//for test
      result ??= [];
      
      return (convertToOutputList(result, (l) => l.id, (l) => l.name), success);
    }
  }

  Future<List<OutputListItem>?> deleteLabel(int id) async{
    bool exist = await DB.hasLabel(id: id);

    if(!exist){
      return null;
    }
    else{
      await DB.deleteLabel(id: id).catchError((e) {
        print('deleteLabel error: $e');   //for test
      });

      List<Label>? result = await DB.getAllLabels();//for test
      result ??= [];
      
      return convertToOutputList(result, (l) => l.id, (l) => l.name);
    }
  }
}