//except build it cannot modify data member

class WordModifyInformation{
    late final String column;
    late final String newInformation;
    
    WordModifyInformation({required String column, required String newInformation}){
      column = column;
      newInformation = newInformation;
    }
}