import 'package:englishvocabdatabase/logic/service/nodefListService.dart';
import 'package:englishvocabdatabase/logic/service/wordService.dart';
import 'package:flutter/foundation.dart';

class ShareProcessor{
  static Future<void> processText(String text, String? definition, String? chinese) async{
    //remain only alaphet
    final regex = RegExp(r'[A-Za-z](?:[A-Za-z-]*[A-Za-z])?');
    final match = regex.firstMatch(text);
    if(match != null && match.group(0) != null){
      debugPrint('process share text ${match.group(0)}');
      if((definition != null && definition != '') ||
          (chinese != null && chinese != '')){
        await WordListService.addWord(match.group(0)!, definition: definition, chinese: chinese);
      }
      else{
        await NodefListService.addNoDef(match.group(0)!);
      }
    }
    else{
      debugPrint('original share text $text fail to match');
    }
    return;
  }
}