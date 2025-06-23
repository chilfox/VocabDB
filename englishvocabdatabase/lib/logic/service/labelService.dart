//handle the outputlist of label

import '../output/outputItem.dart';
import '../../database/label.dart';
import 'template.dart';

class LabelListService{
  late final LabelDB _db;

  LabelListService(){
    _db = LabelDB();
  }

  Future<List<OutputListItem>> initLabelList() async{
    List<Label>? result = await _db.getAllLabels();//for test
    result ??= [];

    return convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname());
  }

  Future<List<OutputListItem>> searchLabel(String prefix) async{
    //for search in database
    List<Label>? result = await _db.searchLabel(prefix);  
    result ??= [];
    return convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname()); 
  }

  Future<(List<OutputListItem>?, int)> addLabel(String name) async{
    bool exist = await _db.hasLabel(label : name);

    if(exist){
      return (null, -1);
    }
    else{
      int success = await _db.addLabel(name).catchError((e){
        print('insertLabel error: $e');  //for test
      });

      if(success == -1){
        return (null, -1);
      }

      List<Label>? result = await _db.getAllLabels();//for test
      result ??= [];
      
      return (convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname()), success);
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
      
      return convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname());
    }
  }
}