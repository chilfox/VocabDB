//except build it cannot modify data member

class WordModifyInformation{
    late final String _column;
    late final String _newInformation;
    
    WordModifyInformation({required String column, required String newInformation}){
      _column = column;
      _newInformation = newInformation;
    }

    String get column => _column;
    String get newInformation => _newInformation;
}