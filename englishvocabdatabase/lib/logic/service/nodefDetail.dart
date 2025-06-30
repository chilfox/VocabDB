import 'package:englishvocabdatabase/database/nodef.dart';
import 'package:englishvocabdatabase/database/db.dart';
import 'package:englishvocabdatabase/logic/output/outputDetailItem.dart';
import 'package:englishvocabdatabase/database/wordModifyInformation.dart';
import 'package:flutter/foundation.dart';

class NodefDetailService{
  static Future<Detail> initNodefDetail(int id) async{
    NoDefinition? result = await DB.searchNoDefDetails(id);

    if(result == null){
      return Detail(name: '', id: -1);
    }
    else{
      Detail detail = Detail(name: result.name, id: result.id, definition: result.definition, parts: result.parts, chinese: result.chinese, sentence: result.sentence);
      return detail;
    }
  }

  static Future<void> storeNodefDetail(Detail detail, int id) async{
    if((detail.chinese != null && detail.chinese != '') 
      || (detail.definition != null && detail.definition != '')){
      //move to word
      debugPrint('move nodef to word');
      DB.deleteNoDef(id);
      int wordId = await DB.addWord(detail.name, chinese: detail.chinese, definition: detail.definition, parts: detail.parts, sentence: detail.sentence);

      return;
    }
    else{
      _storeColumn('definition', detail.definition, id);
      _storeColumn('parts', detail.parts, id);
      _storeColumn('sentence', detail.sentence, id);
      return;
    }
  }

  static Future<void> _storeColumn(String col, String? information, int id) async{
    information ??= '';
    WordModifyInformation newData = WordModifyInformation(column: col, newInformation: information);

    DB.updateNoDef(id, newData);
    return;
  }
}

