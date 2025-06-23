import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../database/wordModifyInformation.dart';

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
    return Detail(name: '', id: 0);
  }

  void ModifyInformation(WordModifyInformation newData){

  }
}

