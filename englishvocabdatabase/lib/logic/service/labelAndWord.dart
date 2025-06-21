import '../../database/label.dart';
//import word database
import '../page/pageInformation.dart';

mixin LabelWordMethod{
  //according to pageInformation
  //this function will add specific word to label
  //or get the word into label
  void addWordToLabel({required int id}){
    if(pageStatus.insideLabel){
      int labelId = pageStatus.labelId;
      //add id word into label
    }
    else{
      int wordId = pageStatus.wordId;
      //add wordid into id label

    }
  }

  void removeWordFromLabel({required int id}){

  }

  void removeAllWordFromLabel(){

  }

  

}