//handle the outputlist of nodef

import '../output/outputItem.dart';
import '../../database/nodef.dart';
import 'template.dart';

class NodefListService{
  late final NoDefDB _db;

  NodefListService(){
    _db = NoDefDB();
  }

  Future<List<OutputListItem>> initNoDefList() async{
    List<NoDefinition>? result = await _db.getAllNoDefs();//for test
    result ??= [];
    return convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname());
  }

  Future<List<OutputListItem>> searchNoDef(String prefix) async{
    //for search in database
    List<NoDefinition>? result = await _db.searchNoDef(prefix);   
    result ??= [];
    return convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname());
  }

  Future<(List<OutputListItem>?, int)> addNoDef(String name) async{
    int success = await _db.addNoDef(name).catchError((e){
      print('insertNodef error: $e');  //for test
    });

    if(success == -1){
      return (null, -1);
    }

    List<NoDefinition>? result = await _db.getAllNoDefs();//for test
    result ??= [];
    return (convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname()), success);
  }

  Future<List<OutputListItem>?> deleteNoDef(int id) async{
    bool exist = await _db.hasNoDef(id);

    if(!exist){
      return null;
    }
    else{
      await _db.deleteNoDef(id).catchError((e) {
        print('delete Nodef error: $e');   //for test
      });

      List<NoDefinition>? result = await _db.getAllNoDefs();//for test
      result ??= [];
      return convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname());
    }
  }
}