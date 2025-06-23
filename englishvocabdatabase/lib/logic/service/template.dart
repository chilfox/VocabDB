import '../output/outputItem.dart';

//convert data from database to outputListItem
List<OutputListItem> convertToOutputList<T>(List<T> input, int Function(T) getId, String Function(T) getName) {
  return input.map((e) => OutputListItem(id: getId(e), name: getName(e))).toList();
}