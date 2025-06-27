import '../output/outputItem.dart';

//convert data from database to outputListItem
List<OutputListItem> convertToOutputList<T>({required List<T> input, required int Function(T) getId, required String Function(T) getName, String? Function(T)? getChinese}) {
  if(getChinese == null){
    return input.map((e) => OutputListItem(id: getId(e), name: getName(e))).toList();
  }
  else{
    return input.map((e) => OutputListItem(id: getId(e), name: getName(e), chinese: getChinese(e))).toList();
  }
}