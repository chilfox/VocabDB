import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../output/outputListNotifier.dart';
import '../page/pageInformation.dart';

//extend class
import 'labelService.dart';
import 'wordService.dart';
import 'noDefinitionService.dart';

final outputServiceProvider = Provider<OutputService>((ref){
  NotifierType type = pageStatus.getNotifierType();
  switch(type){
    case NotifierType.Label:
      return LabelService(ref);
    case NotifierType.Word:
      return WordService(ref);
    case NotifierType.NoDefinition:
      return NoDefinitionService(ref);
  }
});

abstract class OutputService {
  final Ref _ref;

  Ref get ref => _ref;

  OutputService(this._ref);

  Future<bool> search(String prefix);

  Future<bool> add(String name);

  Future<bool> delete(String name, int id) ;
}