import 'package:englishvocabdatabase/logic/service/nodefListService.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'outputItem.dart';
import 'package:meta/meta.dart';

//service
import '../service/labelService.dart';

part 'outputListNotifier.g.dart';

enum NotifierType { NoDefinition, Label, Word}

//service
final _labelListSevice = LabelListService();
final _nodefListService = NodefListService();

@riverpod
class OutputListNotifier extends _$OutputListNotifier {
  @override
  Future<List<OutputListItem>> build(NotifierType type) async{
    switch(type){
      case NotifierType.NoDefinition:
        return _nodefListService.initNoDefList();
      case NotifierType.Label:
        return _labelListSevice.initLabelList();
      case NotifierType.Word:
        return [];
    }
  }

  //search label, nodefinition, word
  Future<bool> search(String prefix) async{
    late List<OutputListItem> result;
    switch(type){
      case NotifierType.NoDefinition:
        result = await _nodefListService.searchNoDef(prefix);
      case NotifierType.Label:
        result = await _labelListSevice.searchLabel(prefix);
      case NotifierType.Word:
        result = [];
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
        (result, newid) = await _nodefListService.addNoDef(name);
      case NotifierType.Label:
        (result, newid) = await _labelListSevice.addLabel(name);
      case NotifierType.Word:
        (result, newid) = ([], -1);
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
        result = await _nodefListService.deleteNoDef(id);
      case NotifierType.Label:
        result = await _labelListSevice.deleteLabel(id);
      case NotifierType.Word:
        result = [];
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

  //remove all output string
  void _removeAll(){
    state = AsyncData([]);
  }
}