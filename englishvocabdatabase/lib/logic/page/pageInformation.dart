import 'package:flutter/widgets.dart';

import '../output/outputListNotifier.dart';

//handle page status and information
PageInformation pageStatus = PageInformation();

class PageInformation {
  NotifierType? _type;

  PageInformation();

  void setNotifierType(NotifierType type){
    _type = type;
    return;
  }

  NotifierType? getNotifierType(){
    return _type;
  }


}