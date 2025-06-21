import '../output/outputListNotifier.dart';

//handle page status and information
PageInformation pageStatus = PageInformation();

class PageInformation {
  late NotifierType _type;  //the type of listviewer
  late bool _insideLabel;
  late int _labelId;
  late bool _insideWord;
  late int _wordId;

  PageInformation(){
    _type = NotifierType.Label;
    _insideLabel = false;
    _insideWord = false;
    _labelId = -1;
    _wordId = -1;
  }

  //getter
  bool get insideLabel => _insideLabel;
  bool get insideword => _insideWord;
  int get labelId => _labelId;
  int get wordId => _wordId;

  void setNotifierType(NotifierType type){
    _type = type;
    return;
  }

  NotifierType getNotifierType(){
    return _type;
  }

  void goIntoLabel({required int id}){
    _insideLabel = true;
    _labelId = id;
  }

  void goOutLabel(){
    _insideLabel = false;
    _labelId = -1;
  }

  void goIntoWord({required int id}){
    _insideWord = true;
    _wordId = id;
  }

  void goOutWord(){
    _insideWord = false;
    _wordId = -1;
  }
}