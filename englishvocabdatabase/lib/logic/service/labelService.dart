//handle the outputlist of label

import '../output/outputItem.dart';
import '../../database/label.dart';

class LabelListService{
  late final LabelDB _db;

  LabelListService(){
    _db = LabelDB();
  }

  Future<List<OutputListItem>> initLabelList() async{
    List<Label>? result = await _db.getAllLabels();//for test
    result ??= [];
      
    List<OutputListItem> outputList = 
      result.map((label) => OutputListItem(id: label.Getid(), name: label.Getname())).toList();

    return outputList;
  }

  Future<List<OutputListItem>> searchLabel(String prefix) async{
    //for search in database
    List<Label>? result = await _db.searchLabel(prefix);   
    if(result == null){
      return [];
    }
    else{
      List<OutputListItem> outputList = 
        result.map((label) => OutputListItem(id: label.Getid(), name: label.Getname())).toList();
      return outputList;
    }
  }

  Future<List<OutputListItem>?> addLabel(String name) async{
    bool exist = await _db.hasLabel(label : name);

    if(exist){
      return null;
    }
    else{
      bool success = await _db.addLabel(name).catchError((e){
        print('insertLabel error: $e');  //for test
      });

      if(!success){
        return null;
      }

      List<Label>? result = await _db.getAllLabels();//for test
      result ??= [];
      
      List<OutputListItem> outputList = 
        result.map((label) => OutputListItem(id: label.Getid(), name: label.Getname())).toList();
      return outputList;
    }
  }

  Future<List<OutputListItem>?> deleteLabel(int id) async{
    bool exist = await _db.hasLabel(id: id);

    if(!exist){
      return null;
    }
    else{
      await _db.deleteLabel(id: id).catchError((e) {
        print('deleteLabel error: $e');   //for test
      });

      List<Label>? result = await _db.getAllLabels();//for test
      result ??= [];
      
      List<OutputListItem> outputList = 
        result.map((label) => OutputListItem(id: label.Getid(), name: label.Getname())).toList();

      return outputList;
    }
  }
}