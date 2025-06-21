import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../page/pageInformation.dart';
import 'package:meta/meta.dart';
//should import word database
import '../test/database_test.dart';

part 'outputDetailNotifier.g.dart';

//information stored in notifier
class Detail{
  late String name;
  late int id;
  String? definition;
  String? parts;
  String? chinese;
  List<String>? labels;
  String? sentence;

  Detail({ required this.name, required this.id,
            this.definition, this.parts, this.chinese, 
            this.labels, this.sentence,
  });

  Detail copyWith({ String? definition, String? parts, String? chinese, 
    List<String>? labels, String? sentence,}) {
    return Detail(
      name: name,
      id: id,
      definition: definition ?? this.definition,
      parts: parts ?? this.parts,
      chinese: chinese ?? this.chinese,
      labels: labels ?? this.labels,
      sentence: sentence ?? this.sentence,
    );
  }
}

//notifier
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

  void ModifyInformation(WordModifyInformation newData){
    state = state.whenData((detail) {
      switch(newData.column){
        case 'definition':
          return detail.copyWith(definition: newData.newInformation);
        case 'parts':
          return detail.copyWith(parts: newData.newInformation);
        case 'chinese':
          return detail.copyWith(chinese: newData.newInformation);
        case 'setence':
          return detail.copyWith(sentence: newData.newInformation);
      }
      throw Exception('Unreachable code: no detail found for modifyInformation in notifier= ${newData.column}');
    });
  }
}

