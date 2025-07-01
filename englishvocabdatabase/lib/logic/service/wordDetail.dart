import 'package:englishvocabdatabase/database/label.dart';
import 'package:englishvocabdatabase/database/word.dart';
import 'package:englishvocabdatabase/database/db.dart';
import 'package:englishvocabdatabase/logic/output/outputDetailItem.dart';
import 'package:englishvocabdatabase/database/wordModifyInformation.dart';

class WordDetailService{
  static Future<Detail> initWordDetail(int id) async{
    Word? result = await DB.searchWordDetails(id);

    if(result == null){
      return Detail(name: '', id: -1);
    }
    else{
      Detail detail = Detail(name: result.name, id: result.id, definition: result.definition, parts: result.parts, chinese: result.chinese, labels: [], sentence: result.sentence);

      //label in the word
      if(result.labels != null){
        for(var label in result.labels!){
          int id = await DB.getLabelid(label);
          detail.labels!.add(LabelItem(id: id, name: label));
        }
      }
      return detail;
    }
  }

  static Future<List<LabelItem>> addLabel(int wordId, int labelId) async{
    await DB.addWordToLabel(wordId, labelId: labelId);
    Word? target = await DB.searchWordDetails(wordId);
  
    return _convertLabelItem(target?.labels);
  }

  static Future<List<LabelItem>> removeLabel(int wordId, int labelId) async{
    await DB.removeWordFromLabel(wordId, labelId: labelId);

    List<String>? labels = (await DB.searchWordDetails(wordId))?.labels;
    return _convertLabelItem(labels);
  }

  //return the label the word does not belong to
  static Future<List<LabelItem>> labelToAdd(int wordId) async{
    List<Label>? allLabel = await DB.getAllLabels();
    if(allLabel == null){
      return [];
    }

    //get the label that this word does not belong to
    List<String>? labelOfThisWord = (await DB.searchWordDetails(wordId))!.labels;
    labelOfThisWord ??= [];

    List<String> result = allLabel
    .where((label) => !labelOfThisWord!.contains(label.name))
    .map((label) => label.name)
    .toList();

    return _convertLabelItem(result);
  }

  static Future<List<LabelItem>> _convertLabelItem(List<String>? labels) async{
    labels ??= [];
    List<LabelItem> item = [];

    for(var label in labels){
      int id = await DB.getLabelid(label);
      LabelItem temp = LabelItem(id: id, name: label);
      item.add(temp);
    }

    return item;
  }

  static Future<void> storeWordDetail(Detail detail, int id) async{
    //avoid word becomes empty
    if((detail.chinese == null || detail.chinese == '') &&
        (detail.definition == null || detail.definition == '') &&
        (detail.parts == null || detail.parts == '') &&
        (detail.sentence == null || detail.sentence == '')){
      return;
    }

    _storeColumn('chinese', detail.chinese, id);
    _storeColumn('definition', detail.definition, id);
    _storeColumn('parts', detail.parts, id);
    _storeColumn('sentence', detail.sentence, id);
    return;
  }

  static Future<void> _storeColumn(String col, String? information, int id) async{
    information ??= '';
    WordModifyInformation newData = WordModifyInformation(column: col, newInformation: information);

    DB.updateWord(id, newData);
    return;
  }
}

