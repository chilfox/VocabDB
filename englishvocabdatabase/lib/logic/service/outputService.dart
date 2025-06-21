//the whole service

import 'package:englishvocabdatabase/logic/service/noDefMethod.dart';
import 'package:englishvocabdatabase/logic/service/wordMethod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../output/outputListNotifier.dart';
import '../page/pageInformation.dart';

//extend class
import 'labelService.dart';
import 'wordService.dart';
import 'noDefinitionService.dart';

//mixin class
import 'labelAndWord.dart';
import 'pageService.dart';
import 'noDefMethod.dart';
import 'wordMethod.dart';

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

abstract class OutputService with PageMethod, LabelWordMethod, 
                                  NodefMethod, WordMethod{
  final Ref _ref;

  Ref get ref => _ref;

  OutputService(this._ref);

  Future<bool> search(String prefix);

  Future<bool> add(String name);

  Future<bool> delete(String name, int id) ;
}