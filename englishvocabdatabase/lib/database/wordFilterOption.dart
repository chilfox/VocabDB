class WordFilterOption{
    late final String _limitLabel;
    late final bool _include;
    
    WordFilterOption({required String limitLabel, required bool include}){
      _limitLabel = limitLabel;
      _include = include;
    }
    
    String get limitLabel => _limitLabel;
    bool get include => _include;
}