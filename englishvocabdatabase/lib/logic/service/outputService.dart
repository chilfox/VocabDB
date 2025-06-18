import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../output/outputItem.dart';
import '../output/outputListNotifier.dart';
import '../page/pageInformation.dart';
import 'package:meta/meta.dart';

@visibleForTesting
import './database_temp.dart';

final outputServiceProvider = Provider((ref) => OutputService(ref));

/* show that how UI should use service
class OutputPage extends ConsumerWidget {
  final NotifierType type;
  const OutputPage({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(outputListNotifierProvider(type));
    final service   = ref.read(outputServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text('輸出 (${type.name})')),
      body: Column(
        children: [
          MonitorListView(listAsync: listAsync),
          TriggerButton(
            onAdd:    (it) => service.addItem(type, it),
            onClear:  ()   => service.clearAll(type),
            onDelete: (id) => service.delete(type, id),
          ),
        ],
      ),
    );
  }
}
*/


class OutputService {
  final Ref _ref;
  OutputService(this._ref);

  Future<bool> search(String prefix) async{
    NotifierType? type = pageStatus.getNotifierType();

    final notifier = _ref.read(outputListNotifierProvider(type).notifier);
    
    //search in data base
    @visibleForTesting
    List<Label>? result = await getDataBase1();
    if(result == null){
      return false;
    }
    else{
      List<OutputListItem> outputList = 
        result.map((label) => OutputListItem(id: label.id, name: label.name)).toList();
      notifier.refreshAll(outputList);
      return true;
    }
  }

  Future<bool> add(String name) async{
    @visibleForTesting
    bool exist = await hasLabel();

    if(exist){
      return false;
    }
    else{
      insertLabel(name).catchError((e){
        print('insertLabel error: $e');  //for test
      });

      return true;
    }
  }

  Future<bool> delete(String name, int id) async{
    bool exist = await hasLabel();

    if(!exist){
      return false;
    }
    else{
      deleteLabel(id).catchError((e) {
        print('deleteLabel error: $e');   //for test
      });

      return true;
    }
  }
}