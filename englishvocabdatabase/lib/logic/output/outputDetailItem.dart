class Detail{
  late String name;
  late int id;
  String? definition;
  String? parts;
  String? chinese;
  List<LabelItem>? labels;
  String? sentence;

  Detail({ required this.name, required this.id,
            this.definition, this.parts, this.chinese, 
            this.labels, this.sentence,
  });

  Detail copyWith({ String? definition, String? parts, String? chinese, 
    List<LabelItem>? labels, String? sentence,}) {
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

//label in word
class LabelItem{
  late final int id;
  late final String name;

  LabelItem({required this.id, required this.name});
}