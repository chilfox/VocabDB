import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'outputItem.dart';

part 'outputListNotifier.g.dart';

@riverpod
class OutputListNotifier extends _$OutputListNotifier{

  @override
  Future<List<OutputListItem>> build() async{
    final data = await _initListData();
    return data;
  }

  //add label or string
  void addOutputString(OutputListItem item){
    // only perform when having data
  state.whenData((current) {
    state = AsyncData([...current, item]);
  });
  }

  //add a List<String> to output List
  void addList(List<OutputListItem> list){
    state.whenData((current){
      state = AsyncData([...current, ...list]);
    });
  }

  //change whole output to new one
  void refreshAll(List<OutputListItem> newOutput){
    state = AsyncData(newOutput);
  }

  //delete the specified string in output
  bool deleteTarget(int id) {
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
  void removeAll(){
    state = AsyncData([]);
  }
}

Future<List<OutputListItem>> _initListData() async{
  await Future.delayed(const Duration(milliseconds: 300));
  return [];
} 