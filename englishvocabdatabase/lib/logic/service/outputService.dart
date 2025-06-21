import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../output/outputItem.dart';
import '../output/outputListNotifier.dart';
import '../page/pageInformation.dart';
import '../../database/label.dart';

part 'labelService.dart';

final outputServiceProvider = Provider<OutputService>((ref){
  NotifierType type = pageStatus.getNotifierType();
  return LabelService(ref);
});

abstract class OutputService {
  final Ref _ref;
  late final _db;

  OutputService(this._ref);

  Future<bool> search(String prefix);

  Future<bool> add(String name);

  Future<bool> delete(String name, int id) ;
}