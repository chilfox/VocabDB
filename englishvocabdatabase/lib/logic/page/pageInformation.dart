import '../output/outputListNotifier.dart';

//handle page status and information
PageInformation pageStatus = PageInformation();

class PageInformation {
  NotifierType _type;

  PageInformation({NotifierType type = NotifierType.Label}) : _type = type;

  void setNotifierType(NotifierType type){
    _type = type;
    return;
  }

  NotifierType getNotifierType(){
    return _type;
  }


}