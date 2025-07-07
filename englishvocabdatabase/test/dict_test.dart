import 'package:englishvocabdatabase/dictionary/dictionary.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var diction = Dictionary();
  var hello_result = await diction.fetchdata("flow");
  if(hello_result == null){
    return;
  }
  for(var word in hello_result){
    print("id:${word.id}, word:${word.name}, meaning:${word.definition}, example:${word.sentence}");
  }
}