//handle the method to set the status of page

import '../page/pageInformation.dart';

mixin PageMethod{
  void goIntoLabel({required int id}){
    pageStatus.goIntoLabel(id: id);
  }

  void leaveLabel(){
    pageStatus.goOutLabel();
  }

  void goIntoWord({required int id}){
    pageStatus.goIntoWord(id: id);
  }

  void leaveWord(){
    pageStatus.goOutWord();
  }
}