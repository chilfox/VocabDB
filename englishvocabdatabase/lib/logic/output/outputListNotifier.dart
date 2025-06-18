import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'outputListNotifier.g.dart';

@riverpod
class OutputListNotifier extends _$OutputListNotifier{
  @override
  List<String> build(){
    return [];
  }

  //add label or string
  void addOutputString(String name){
    state = [...state, name];
  }

  //add a List<String> to output List
  void addList(List<String> list){
    state = [...state, ...list];
  }

  //change whole output to new one
  void refreshAll(List<String> newOutput){
    state = newOutput;
  }

  //delete the specified string in output
  bool deleteTarget(String name){
    int index = state.indexOf(name);
    if(index == -1){
      return false;
    }
    else{
      List<String> first = [];
      if(index > 0){
        first = state.sublist(0, index);
      }
      
      List<String> second = [];
      if(index < state.length - 1){
        second = state.sublist(index + 1);
      }

      state = [...first, ...second];
      return true;
    }
  }

  //remove all output string
  void removeAll(){
    state = [];
  }
}