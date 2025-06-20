class Label{
  final int id;
  final String name;
  final int wordnum;

  Label({required this.id, required this.name, required this.wordnum});
}

Future<List<Label>?> getDataBase1() async{
  Label label1 = Label(id: 1, name: 'test1-1', wordnum: 4);
  Label label2 = Label(id: 2, name: 'test1-2', wordnum: 1);

  await Future.delayed(const Duration(seconds: 2));
  
  return [label1, label2];
}

Future<List<Label>?> getDataBase2() async{
  Label label1 = Label(id: 1, name: 'test2-1', wordnum: 4);
  Label label2 = Label(id: 2, name: 'test2-2', wordnum: 1);

  await Future.delayed(const Duration(seconds: 2));
  
  return [label1, label2];
}

Future<List<Label>?> getDataBase3() async{
  Label label1 = Label(id: 1, name: 'test3-1', wordnum: 4);
  Label label2 = Label(id: 2, name: 'test3-2', wordnum: 1);

  await Future.delayed(const Duration(seconds: 2));
  
  return [label1, label2];
}


Future<bool> hasLabel() async{
  return false;
}

Future<void> insertLabel(String name) async{
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> deleteLabel(int id) async{
  await Future.delayed(const Duration(seconds: 2));
}