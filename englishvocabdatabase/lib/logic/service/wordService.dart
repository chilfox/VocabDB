//handle output list of word

import 'package:englishvocabdatabase/database/label.dart';

import '../output/outputItem.dart';
//import word database
import 'template.dart';


class WordListService{
  late final WordDB _db;

  WordListService(){
    _db = LabelDB();
  }

  Future<List<OutputListItem>> initWordList() async{
    List<Label>? result = await _db.getAllLabels();//for test
    result ??= [];

    return convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname());
  }

  Future<List<OutputListItem>> searchWord(String prefix) async{
    //for search in database
    List<Label>? result = await _db.searchLabel(prefix);  
    result ??= [];
    return convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname()); 
  }

  Future<(List<OutputListItem>?, int)> addWord(String name) async{
    bool exist = await _db.hasLabel(label : name);

    if(exist){
      return (null, -1);
    }
    else{
      int success = await _db.addLabel(name).catchError((e){
        print('insertLabel error: $e');  //for test
      });

      if(success == -1){
        return (null, -1);
      }

      List<Label>? result = await _db.getAllLabels();//for test
      result ??= [];
      
      return (convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname()), success);
    }
  }

  Future<List<OutputListItem>?> deleteWord(int id) async{
    bool exist = await _db.hasLabel(id: id);

    if(!exist){
      return null;
    }
    else{
      await _db.deleteLabel(id: id).catchError((e) {
        print('deleteLabel error: $e');   //for test
      });

      List<Label>? result = await _db.getAllLabels();//for test
      result ??= [];
      
      return convertToOutputList(result, (l) => l.Getid(), (l) => l.Getname());
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