import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'outputItem.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

//service
import 'package:englishvocabdatabase/logic/service/labelService.dart';
import 'package:englishvocabdatabase/logic/service/nodefListService.dart';
import 'package:englishvocabdatabase/logic/service/wordService.dart';

part 'outputListNotifier.g.dart';

enum NotifierType { NoDefinition, Label, Word}

@riverpod
class OutputListNotifier extends _$OutputListNotifier {
  @override
  Future<List<OutputListItem>> build(NotifierType type, {bool? inlabel, int? labelId}) async{
    switch(type){
      case NotifierType.NoDefinition:
        return NodefListService.initNoDefList();
      case NotifierType.Label:
        return LabelListService.initLabelList();
      case NotifierType.Word:
        if(inlabel == null){
          return WordListService.initWordList();
        }
        else if(inlabel){
          return WordListService.searchWordToLabel('', labelId!, true);
        }
        else{
          return WordListService.searchWordToLabel('', labelId!, false);
        }
    }
  }

  //search label, nodefinition, word
  Future<bool> search(String prefix) async{
    late List<OutputListItem> result;
    switch(type){
      case NotifierType.NoDefinition:
        result = await NodefListService.searchNoDef(prefix);
      case NotifierType.Label:
        result = await LabelListService.searchLabel(prefix);
      case NotifierType.Word:
        result = await WordListService.searchWord(prefix);
    }

    _refreshAll(result);
    return (result == [] ? false : true);
  }

  //add label, nodefinition, word
  Future<int> add(String name) async{
    List<OutputListItem>? result;
    late int newid;
    switch(type){
      case NotifierType.NoDefinition:
        (result, newid) = await NodefListService.addNoDef(name);
      case NotifierType.Label:
        (result, newid) = await LabelListService.addLabel(name);
      case NotifierType.Word:
        (result, newid) = await NodefListService.addNoDef(name);
    }

    if (result == null) return -1;
    _refreshAll(result);
    return newid;
  }

  //delete label, nodefinition, word
  Future<bool> delete(int id) async{
    List<OutputListItem>? result;
    switch(type){
      case NotifierType.NoDefinition:
        result = await NodefListService.deleteNoDef(id);
      case NotifierType.Label:
        result = await LabelListService.deleteLabel(id);
      case NotifierType.Word:
        result = await WordListService.deleteWord(id);
    }

    if(result == null){
      //add fail
      return false;
    }
    else{
      //add success
      _refreshAll(result);
      return true;
    }
  }

  //the method for word related to label
  Future<bool> searchInLabel(String prefix) async{
    if(labelId == null){
      return false;
    }
    debugPrint('inlabel search $labelId $prefix');
    List<OutputListItem> result = await WordListService.searchWordToLabel(prefix, labelId!, true);

    _refreshAll(result);
    return (result == [] ? false : true);
  }
  
  Future<bool> searchNotInLabel(String prefix) async{
    if(labelId == null){
      return false;
    }
    debugPrint('not inlabel insearch $labelId $prefix');
    List<OutputListItem> result = await WordListService.searchWordToLabel(prefix, labelId!, false);

    _refreshAll(result);
    return (result == [] ? false : true);
  }
  
  Future<bool> addWordToLabel(int wordId, int labelId) async{
    await WordListService.addWordToLabel(wordId, labelId);

    //list should only have word not in label
    _deleteTarget(wordId);
    return true;
  }
  
  Future<bool> removeWordFromLabel(int wordId, int labelId) async{
    bool success = await WordListService.removeWord(wordId: wordId, labelId: labelId);

    if(success){
      //list should only have words in label
      _deleteTarget(wordId);
      return true;
    }
    else{
      return false;
    }
  }
  
  Future<bool> removeAllWord(int labelId) async{
    bool success = await WordListService.removeWord(labelId: labelId);
    _refreshAll([]);
    return success;
  }

  //add label or string
  void _addOutputString(OutputListItem item){
    // only perform when having data
    state.whenData((current) {
      state = AsyncData([...current, item]);
    });
  }

  //add a List<String> to output List
  void _addList(List<OutputListItem> list){
    state.whenData((current){
      state = AsyncData([...current, ...list]);
    });
  }

  //change whole output to new one
  void _refreshAll(List<OutputListItem> newOutput){
    state = AsyncData(newOutput);
  }

  //delete the specified string in output
  bool _deleteTarget(int id) {
    if (state is! AsyncData){
      return false;
    }
    
    final current = (state as AsyncData<List<OutputListItem>>).value;
    final index = current.indexWhere((e) => e.id == id);
    if (index == -1){
      return false;
    }

    final newList = [...current]..removeAt(index);
    state = AsyncData(newList);
    return true;
  }
}