import 'package:englishvocabdatabase/logic/service/nodefListService.dart';
import 'package:flutter/foundation.dart';

class ShareProcessor{
  static Future<void> processText(String text) async{
    //remain only alaphet
    RegExp regex = RegExp(r'^[a-zA-Z]+(-[a-zA-Z]+)*$');
    final match = regex.firstMatch(text);
    if(match != null && match.group(0) != null){
      debugPrint('process share text ${match.group(0)}');
      await NodefListService.addNoDef(match.group(0)!);
      return;
    }
    else{
      debugPrint('original share text $text fail to match');
    }
  }
}