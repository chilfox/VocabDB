//handle the outputlist of nodef

import '../output/outputItem.dart';
import '../../database/nodef.dart';

class NodefListService{
  late final NoDefDB _db;

  NodefListService(){
    _db = NoDefDB();
  }

  Future<List<OutputListItem>> initNoDefList() async{
    List<NoDefinition>? result = await _db.getAllNoDefs();//for test
    result ??= [];
      
    List<OutputListItem> outputList = 
      result.map((nodef) => OutputListItem(id: nodef.Getid(), name: nodef.Getname())).toList();

    return outputList;
  }

  Future<List<OutputListItem>> searchNoDef(String prefix) async{
    //for search in database
    List<NoDefinition>? result = await _db.searchNoDef(prefix);   
    if(result == null){
      return [];
    }
    else{
      List<OutputListItem> outputList = 
        result.map((nodef) => OutputListItem(id: nodef.Getid(), name: nodef.Getname())).toList();
      return outputList;
    }
  }

  Future<List<OutputListItem>?> addNoDef(String name) async{
    bool success = await _db.addNoDef(name).catchError((e){
      print('insertNodef error: $e');  //for test
    });

    if(!success){
      return null;
    }

    List<NoDefinition>? result = await _db.getAllNoDefs();//for test
    result ??= [];
    
    List<OutputListItem> outputList = 
      result.map((nodef) => OutputListItem(id: nodef.Getid(), name: nodef.Getname())).toList();
    return outputList;
  }

  Future<List<OutputListItem>?> deleteNoDef(int id) async{
    bool exist = await _db.hasNoDef(id: id);

    if(!exist){
      return null;
    }
    else{
      await _db.deleteNoDef(id: id).catchError((e) {
        print('delete Nodef error: $e');   //for test
      });

      List<NoDefinition>? result = await _db.getAllNoDefs();//for test
      result ??= [];
      
      List<OutputListItem> outputList = 
        result.map((nodef) => OutputListItem(id: nodef.Getid(), name: nodef.Getname())).toList();

      return outputList;
    }
  }
}