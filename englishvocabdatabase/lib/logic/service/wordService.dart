//handle output list of word

import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/database/db.dart';
import 'package:englishvocabdatabase/database/label.dart';
import 'package:englishvocabdatabase/database/word.dart';
import 'template.dart';


class WordListService{
  Future<List<OutputListItem>> initWordList() async{
    List<Word>? result = await DB.getAllWords();//for test
    result ??= [];

    return convertToOutputList(result, (l) => l.id, (l) => l.name);
  }

  Future<List<OutputListItem>> searchWord(String prefix) async{
    //for search in database
    List<Word>? result = await DB.searchWord(prefix);  
    result ??= [];
    return convertToOutputList(result, (l) => l.id, (l) => l.name); 
  }

  Future<(List<OutputListItem>?, int)> addWord(String name) async{
    int newId = await DB.addWord(name).catchError((e){
      print('insertWord error: $e');  //for test
    });

    if(newId == -1){
      return (null, -1);
    }

    List<Word>? result = await DB.getAllWords();//for test
    result ??= [];
    
    return (convertToOutputList(result, (l) => l.id, (l) => l.name), newId);
  }

  Future<List<OutputListItem>?> deleteWord(int id) async{
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
      
      return convertToOutputList(result, (l) => l.id, (l) => l.name);
    }
  }

  Future<List<OutputListItem>> searchWordToLabel(String prefix, int labelId, bool inlabel) async{
    return [];
  }

  Future<bool> addWordToLabel(int wordId, int labelId) async{
    return true;
  }

  //from label
  Future<bool> removeWord({int? wordId, required int labelId}) async{
    if(wordId == null){
      //remove all word from labelId
      return true;
    }
    else{
      return true;
    }
  }
}