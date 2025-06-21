class NoDefinition{
  late final int id;
  late final String name;

  NoDefinition({required int this.id, required String this.name});
}

class Word {
  final int id;
  final String name;
  String definition;
  String parts;    //詞性
  String? chinese;
  final List<String>? labels; // 儲存該單字所屬的標籤ID;
  String? setence;
}



Future<bool> hasWord(int id) => Future.value(true);
Future<bool> hasNoDefinition(int id)=> Future.value(true);
Future<NoDefinition?> findNoDefinition(int id) => Future.value(NoDefinition(id: 1, name: 'test'));

Future<Word?> findWord(int id) => null;