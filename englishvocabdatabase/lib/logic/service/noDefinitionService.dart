//handle the outputlist of noDefinition

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../output/outputItem.dart';
import '../output/outputListNotifier.dart';
import '../page/pageInformation.dart';
import '../../database/nodef.dart';

//abstract class
import 'outputService.dart';

class NoDefinitionService extends OutputService{
  late final _db;

  NoDefinitionService(Ref ref): super(ref){
    _db = NoDefDB();
  }

  @override
  Future<bool> search(String prefix) async{
    NotifierType? type = pageStatus.getNotifierType();

    final notifier = ref.read(outputListNotifierProvider(type).notifier);
    
    //for search in database
    List<NoDefinition>? result = await _db.searchNoDef(prefix);   
    if(result == null){
      return false;
    }
    else{
      List<OutputListItem> outputList = 
        result.map((nodef) => OutputListItem(id: nodef.Getid(), name: nodef.Getname())).toList();
      notifier.refreshAll(outputList);
      return true;
    }
  }
  
  @override
  Future<bool> add(String name) async{
    NotifierType? type = pageStatus.getNotifierType();

    final notifier = ref.read(outputListNotifierProvider(type).notifier);

    bool success = await _db.addNoDef(name).catchError((e){
      print('insertLabel error: $e');
    });

    if(!success){
      return false;
    }

    List<NoDefinition>? result = await _db.getAllNoDefs();
    result ??= [];
    
    List<OutputListItem> outputList = 
      result.map((nodef) => OutputListItem(id: nodef.Getid(), name: nodef.Getname())).toList();
    notifier.refreshAll(outputList);

    return true;
  }

  @override
  Future<bool> delete(String name, int id) async{
    bool exist = await _db.hasLabel(id: id);

    if(!exist){
      return false;
    }
    else{
      NotifierType? type = pageStatus.getNotifierType();

      final notifier = ref.read(outputListNotifierProvider(type).notifier);
      await _db.deleteNoDef(id: id).catchError((e) {
        print('deleteLabel error: $e');   //for test
      });

      List<NoDefinition>? result = await _db.getAllNoDefs();//for test
      result ??= [];
      
      List<OutputListItem> outputList = 
        result.map((nodef) => OutputListItem(id: nodef.Getid(), name: nodef.Getname())).toList();
      notifier.refreshAll(outputList);

      return true;
    }
  }
}