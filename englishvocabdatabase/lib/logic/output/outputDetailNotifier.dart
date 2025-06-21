import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../page/pageInformation.dart';
import 'package:meta/meta.dart';
//should import word database
import '../test/database_test.dart';

part 'outputDetailNotifier.g.dart';

class Detail{
  late String name;
  late int id;
  String? definition;
  String? parts;
  String? chinese;
  List<String>? labels;
  String? sentence;

  Detail({required this.name, required this.id});
}

@riverpod
class OutputDetailNotifier extends _$OutputDetailNotifier{
  //information
  @override
  Future<Detail> build() async{
    int wordId = pageStatus.wordId;
    assert(wordId != -1);

    bool isword = await hasWord(wordId);  //should call word database
    if(!isword){
      assert(await hasNoDefinition(wordId));
      //this is still a string not a word
      NoDefinition? word = await findNoDefinition(wordId);
      return Detail(name: word!.name, id: word!.id);
    }
    else{
      //is a word
      Word? word = await findWord(wordId);

      //change word information into Detail
      return Detail(name: word!.name, id: word!.id);
    }
  }
}

