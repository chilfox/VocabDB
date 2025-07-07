import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:englishvocabdatabase/dictionary/dictionary.dart';
import 'package:englishvocabdatabase/database/word.dart';
import 'package:flutter/foundation.dart';

class DictService{
  static final _diction = Dictionary();
  static String wordname = '';
  static List<Word> pending = [];

  //store information in pending
  static Future<void> searchWord(String name) async{
    debugPrint('enter dictservice $name');
    wordname = name;
    pending = await _diction.fetchdata(name) ?? [];
    debugPrint('dict get $pending');
    return;
  }

  static List<String> getDefinition() {
    debugPrint('dictservice getDefinition');
    return pending.map((word) => word.definition).whereType<String>().toList();
  }

  static List<String> getSentence(){
    debugPrint('dictservice getSentence');
    return pending.map((word) => word.sentence).whereType<String>().toList();
  }

  static List<String> getParts(){
    debugPrint('dictservice getParts');
    return pending.map((word) => word.parts).whereType<String>().toList();
  }

  //according to definition
  static Word getWord(String definition){
    Word word = pending.firstWhere((word) => word.definition == definition,
                              orElse: () => Word(id: -1, name: wordname));
    debugPrint('dictservice getWord $word');
    return word;
  }
}