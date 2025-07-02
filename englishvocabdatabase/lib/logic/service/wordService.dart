//handle output list of word

import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/database/db.dart';
import 'package:englishvocabdatabase/database/word.dart';
import 'package:englishvocabdatabase/database/label.dart';
import 'package:englishvocabdatabase/database/wordFilterOption.dart';
import 'package:englishvocabdatabase/logic/output/outputDetailItem.dart';
import 'template.dart';
import 'package:flutter/foundation.dart';

class WordListService{
  static Future<List<OutputListItem>> initWordList() async{
    List<Word>? result = await DB.getAllWords();//for test
    result ??= [];

    return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name, getChinese: (l) => l.chinese);
  }

  static Future<List<OutputListItem>> searchWord(String prefix) async{
    //for search in database
    List<Word>? result = await DB.searchWord(prefix);  
    result ??= [];
    return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name, getChinese: (l) => l.chinese); 
  }

  static Future<(List<OutputListItem>?, int)> addWord(String name) async{
    int newId = await DB.addWord(name).catchError((e){
      print('insertWord error: $e');  //for test
    });

    if(newId == -1){
      return (null, -1);
    }

    List<Word>? result = await DB.getAllWords();//for test
    result ??= [];
    
    return (convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name, getChinese: (l) => l.chinese), newId);
  }

  static Future<List<OutputListItem>?> deleteWord(int id) async{
    bool exist = await DB.hasWord(id);

    if(!exist){
      return null;
    }
    else{
      await DB.deleteWord(id).catchError((e) {
        print('deleteWord error: $e');   //for test
      });

      List<Word>? result = await DB.getAllWords();//for test
      result ??= [];
      
      return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name, getChinese: (l) => l.chinese);
    }
  }

  static Future<List<OutputListItem>> searchWordToLabel(String prefix, int labelId, bool inlabel) async{
    String? labelname = await DB.getLabelname(labelId);
    if(labelname == null){
      //no such label
      return [];
    }
    debugPrint('search word to label $inlabel');
    WordFilterOption limit = WordFilterOption(limitLabel: labelname, include: inlabel);

    List<Word>? result = await DB.getWordDetails(option: limit, start: 0);
    result ??= [];

    return convertToOutputList(input: result, getId: (l) => l.id, getName: (l) => l.name, getChinese: (l) => l.chinese);
  }

  //return the new label of this word
  static Future<bool> addWordToLabel(int wordId, int labelId) async{
    await DB.addWordToLabel(wordId, labelId: labelId);

    return true;
  }

  //from label
  static Future<bool> removeWord({int? wordId, required int labelId}) async{
    if(wordId == null){
      //remove all word from labelId
      await DB.removeAllWordsFromLabel(labelId: labelId);
      return true;
    }
    else{
      await DB.removeWordFromLabel(wordId, labelId: labelId);
      return true;
    }
  }
}