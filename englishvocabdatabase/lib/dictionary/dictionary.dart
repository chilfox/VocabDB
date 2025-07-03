import 'package:http/http.dart'as http;
import '../database/word.dart';
import 'dart:convert';
import 'dictionary_model.dart';
import 'package:flutter/widgets.dart';

class dictionary{
  String baseurl = "https://api.dictionaryapi.dev/api/v2/entries/en/";
  Future <List<Word>?> fetchdata(String word) async{
    Uri url = Uri.parse("$baseurl$word");
    final response = await http.get(url);
    if(response.statusCode == 200){
        final data = json.decode(response.body); //data is in List<Map,dynamic>
        if(data.isNotEmpty){
            List<Word> result = [];
            var dictionary_model = DictionaryModel.fromJson(data[0]);
            List<Meaning> meaning_list = dictionary_model.meanings;
            for(var meaning in meaning_list){
                String parts = meaning.partOfSpeech;
                List<Definition> definitions = meaning.definitions;
                for(var def in definitions){
                  String definition = def.definition;
                  String? sentence = def.example;
                  result.add(Word(id: -1, name: word, definition: definition, sentence: sentence));
                }
            }
            return result;
        }
    }
    return null;
  }

}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var diction = dictionary();
  var hello_result = await diction.fetchdata("flow");
  if(hello_result == null){
    return;
  }
  for(var word in hello_result){
    print("id:${word.id}, word:${word.name}, meaning:${word.definition}, example:${word.sentence}");
  }
}
*/