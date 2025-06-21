//wait for word database

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../output/outputItem.dart';
import '../output/outputListNotifier.dart';
import '../page/pageInformation.dart';
import '../../database/label.dart';

//abstract class
import 'outputService.dart';

class WordService extends OutputService{
  late final _db;

  WordService(Ref ref): super(ref){
    _db = LabelDB();
  }

  @override
  Future<bool> search(String prefix) async{
    NotifierType? type = pageStatus.getNotifierType();

    final notifier = ref.read(outputListNotifierProvider(type).notifier);
    
    //for search in database
    List<Label>? result = await _db.searchLabel(prefix);   
    if(result == null){
      return false;
    }
    else{
      List<OutputListItem> outputList = 
        result.map((label) => OutputListItem(id: label.Getid(), name: label.Getname())).toList();
      notifier.refreshAll(outputList);
      return true;
    }
  }
  
  @override
  Future<bool> add(String name) async{
    bool exist = await _db.hasLabel(label : name);

    if(exist){
      return false;
    }
    else{
      NotifierType? type = pageStatus.getNotifierType();

      final notifier = ref.read(outputListNotifierProvider(type).notifier);

      bool success = await _db.addLabel(name).catchError((e){
        print('insertLabel error: $e');  //for test
      });

      if(!success){
        return false;
      }

      List<Label>? result = await _db.getAllLabels();//for test
      result ??= [];
      
      List<OutputListItem> outputList = 
        result.map((label) => OutputListItem(id: label.Getid(), name: label.Getname())).toList();
      notifier.refreshAll(outputList);

      return true;
    }
  }

  @override
  Future<bool> delete(String name, int id) async{
    bool exist = await _db.hasLabel(label: name);

    if(!exist){
      return false;
    }
    else{
      NotifierType? type = pageStatus.getNotifierType();

      final notifier = ref.read(outputListNotifierProvider(type).notifier);
      await _db.deleteLabel(id: id).catchError((e) {
        print('deleteLabel error: $e');   //for test
      });

      List<Label>? result = await _db.getAllLabels();//for test
      result ??= [];
      
      List<OutputListItem> outputList = 
        result.map((label) => OutputListItem(id: label.Getid(), name: label.Getname())).toList();
      notifier.refreshAll(outputList);

      return true;
    }
  }
}