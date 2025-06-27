import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:englishvocabdatabase/database/wordModifyInformation.dart';
import 'package:englishvocabdatabase/database/label.dart';

part 'outputDetailNotifier.g.dart';

//information stored in notifier
class Detail{
  late String name;
  late int id;
  String? definition;
  String? parts;
  String? chinese;
  List<Label>? labels;
  String? sentence;

  Detail({ required this.name, required this.id,
            this.definition, this.parts, this.chinese, 
            this.labels, this.sentence,
  });

  Detail copyWith({ String? definition, String? parts, String? chinese, 
    List<Label>? labels, String? sentence,}) {
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
    return Detail(name: '', id: 0);
  }

  Future<bool> modifyDetail(String column, String newInformation) async{

  }
  
  Future<bool> addWordToLabel(int wordId, int labelId) async{

  }
  
  Future<bool> removeWordFromLabel(int wordId, int labelId) async{

  }

  Future<void> storeDetail() async{

  }

  void _updateLabel(List<Label> labels){
    state.whenData((current) {
      Detail newDetail = current.copyWith(labels: labels);
      state = AsyncValue.data(newDetail);
    });
    return;
  }

  //help modify detail
  void _detailHelper(String column, String newInformation){
    state.whenData((current) {
      Detail newDetail;
      switch (column) {
        case 'definition':
          newDetail = current.copyWith(definition: newInformation);
          break;
        case 'parts':
          newDetail = current.copyWith(parts: newInformation);
          break;
        case 'chinese':
          newDetail = current.copyWith(chinese: newInformation);
          break;
        case 'sentence':
          newDetail = current.copyWith(sentence: newInformation);
          break;
        default:
          return; // 直接中止，不做任何事
      }

      state = AsyncValue.data(newDetail);
    });
    return;
  }
}