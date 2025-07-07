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

  static Future<int> addWord(String name, {String? definition, String? chinese, String? parts, String? sentence}) async{
    int newId = await DB.addWord(name, definition: definition, chinese: chinese, parts: parts, sentence: sentence).catchError((e){
      print('insertWord error: $e');  //for test
    });

    await DB.addWordToLabel(newId, label: 'nolabel');
    
    return newId;
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

  static Future<List<OutputListItem>> searchWordToLabel(String prefix, int labelId, bool inlabel, {String? labelname}) async{
    labelname ??= await DB.getLabelname(labelId);
    if(labelname == null){
      //no such label
      return [];
    }

    WordFilterOption option = WordFilterOption(limitLabel: labelname, include: inlabel);
    //find the word in this label
    List<Word>? wordInLabel = await DB.getWordDetails(start: 0, option: option);
    wordInLabel ??= [];

    List<Word> result = wordInLabel.where((w) => w.name.startsWith(prefix)).toList();

    List<Word> filteredList = result.where((word) => word.name.startsWith(prefix)).toList();

    debugPrint('result is $filteredList');
    return convertToOutputList(input: filteredList, getId: (l) => l.id, getName: (l) => l.name, getChinese: (l) => l.chinese);
  }

  //return the new label of this word
  static Future<bool> addWordToLabel(int wordId, int labelId) async{
    await DB.removeWordFromLabel(wordId, label: 'nolabel');
    await DB.addWordToLabel(wordId, labelId: labelId);

    return true;
  }

  //from label
  static Future<bool> removeWord({int? wordId, required int labelId}) async{
    if(wordId == null){
      //remove all word from labelId
      List<Word>? wordList = await DB.getWordsByLabel(labelId: labelId);
      await DB.removeAllWordsFromLabel(labelId: labelId);

      if(wordList != null){
        for(var i in wordList){
          if(i.labels == [] || i.labels == null){
            DB.addWordToLabel(i.id, label: 'nolabel');
          }
        }
      }

      return true;
    }
    else{
      await DB.removeWordFromLabel(wordId, labelId: labelId);
      Word? detail = await DB.searchWordDetails(wordId);
      if(detail!.labels == [] || detail.labels == null){
        await DB.addWordToLabel(wordId, label: 'nolabel');
      }

      return true;
    }
  }
}