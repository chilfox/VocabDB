import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:englishvocabdatabase/logic/service/dictService.dart';
import 'package:englishvocabdatabase/logic/service/wordDetail.dart';
import 'package:englishvocabdatabase/database/word.dart';
import 'package:englishvocabdatabase/logic/service/nodefDetail.dart';
import 'package:flutter/foundation.dart';

part 'outputDictNotifier.g.dart';

@riverpod
class OutputDictNotifier extends _$OutputDictNotifier{
  
  //先回傳definition
  @override
  Future<List<String>> build(String wordname) async{
    await DictService.searchWord(wordname);
    return DictService.getDefinition();
  }

  void getDefinition() {
    state.whenData((current){
      state = AsyncValue.data(DictService.getDefinition());
    });
    return;
  }

  void getSentence(){
    state.whenData((current){
      state = AsyncValue.data(DictService.getSentence());
    });
    return;
  }

  Future<Word> getWordByDefinition(String definition) async{
    return DictService.getWord(definition);
  }
}
