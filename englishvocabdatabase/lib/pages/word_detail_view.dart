import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/logic/output/outputDetailItem.dart';
import 'package:englishvocabdatabase/logic/output/outputDetailNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/logic/output/outputDictNotifier.dart';
import 'package:englishvocabdatabase/pages/suggestion_text_field.dart';

class WordDetailView extends ConsumerStatefulWidget {
  final OutputListItem? label;
  final int wordId;
  final String wordName;
  final bool startWithEditView;
  final bool nodef; // 新增參數

  const WordDetailView({
    super.key,
    required this.label,
    required this.wordId,
    required this.wordName,
    required this.startWithEditView,
    required this.nodef, // 新增必要參數
  });

  @override
  ConsumerState<WordDetailView> createState() => _WordDetailViewState();
}

class _WordDetailViewState extends ConsumerState<WordDetailView> {
  bool _isEditing = false;
  late bool _isNoDef; // Dynamic state for isNoDef
  
  // Text editing controllers
  late final TextEditingController _chineseController;
  late final TextEditingController _definitionController;
  late final TextEditingController _partsController;
  late final TextEditingController _sentenceController;

  //Text suggestion show or not
  bool _showDefinitionSuggestions = false;
  bool _showSentenceSuggestions   = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.startWithEditView;
    _isNoDef = widget.nodef; // Initialize with widget.nodef
    _initializeControllers();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _initializeControllers() {
    _chineseController = TextEditingController();
    _definitionController = TextEditingController();
    _partsController = TextEditingController();
    _sentenceController = TextEditingController();
  }

  void _disposeControllers() {
    _chineseController.dispose();
    _definitionController.dispose();
    _partsController.dispose();
    _sentenceController.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges(Detail word, OutputDetailNotifier service) async {
    final updatedWord = _createUpdatedWord(word);
    final log = AppLocalizations.of(context)!;
    
    // Check if content was added - this will determine if NoDef should become Word
    bool hasContent = _hasWordContent(updatedWord);
    bool wasNoDef = _isNoDef;
    
    try {
      await _updateWordInService(updatedWord, service);
      
      // Only update _isNoDef after storeDetail is successfully called
      if (hasContent && wasNoDef) {
        setState(() {
          _isNoDef = false; // Change state globally AFTER successful storeDetail
        });
      }
      
      _exitEditMode();
      _showSuccessMessage();
      if(hasContent && wasNoDef){
        if (!context.mounted) return;
        Navigator.pop(context);
      }
    } catch (error) {
      // Handle error if storeDetail fails
      _showErrorMessage(log.eventSaveFail(error));
    }
  }

  bool _hasWordContent(Detail word) {
    return (word.definition?.isNotEmpty ?? false) ||
           (word.chinese?.isNotEmpty ?? false) ||
           (word.parts?.isNotEmpty ?? false) ||
           (word.sentence?.isNotEmpty ?? false);
  }

  Detail _createUpdatedWord(Detail word) {
    return Detail(
      id: word.id,
      name: word.name,
      chinese: _chineseController.text.isEmpty ? null : _chineseController.text,
      definition: _definitionController.text.isEmpty ? null : _definitionController.text,
      parts: _partsController.text.isEmpty ? null : _partsController.text,
      sentence: _sentenceController.text.isEmpty ? null : _sentenceController.text,
      labels: word.labels,
    );
  }

  Future<void> _updateWordInService(Detail updatedWord, OutputDetailNotifier service) async {
    await updateWord(updatedWord, service, _isNoDef); // Use dynamic _isNoDef
  }

  void _exitEditMode() {
    _toggleEditMode();
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.doneWordUpdate),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _cancelEdit() {
    _toggleEditMode();
  }

  AsyncValue<Detail> _getWordData() {
    final detailType = _isNoDef // Use dynamic _isNoDef
        ? DetailType.NodefDetail 
        : DetailType.WordDetail;
    return ref.watch(outputDetailNotifierProvider(detailType, widget.wordId));
  }

  OutputDetailNotifier _getService() {
    final detailType = _isNoDef // Use dynamic _isNoDef
        ? DetailType.NodefDetail 
        : DetailType.WordDetail;
    return ref.watch(outputDetailNotifierProvider(detailType, widget.wordId).notifier);
  }

  // Helper method to check if this is a NoDefinition word (only has id and name)
  bool _isNoDefinitionWord(Detail word) {
    return _isNoDef; // Use dynamic _isNoDef
  }

  //--suggestion method--//
  void _onTapDefinitionField(){ 
    final dictNotifier = ref.read(outputDictNotifierProvider(widget.wordName).notifier);
    dictNotifier.getDefinition();
    setState(() {
      _showDefinitionSuggestions = true;
      _showSentenceSuggestions   = false;
    });
  }

  void _onTapSentenceField(){ 
    final dictNotifier = ref.read(outputDictNotifierProvider(widget.wordName).notifier);
    dictNotifier.getSentence();
    setState(() {
      _showDefinitionSuggestions = false;
      _showSentenceSuggestions   = true;
    });
  }

  void _onDefinitionSelected(String suggestion) async {
    _definitionController.text = suggestion;

    final wordData = await ref
      .read(outputDictNotifierProvider(widget.wordName).notifier)
      .getWordByDefinition(suggestion);
    //檢查parts, sentence是否為空 自動填入
    if (_sentenceController.text.isEmpty) {
      _sentenceController.text = wordData.sentence ?? '';
    }
    if (_partsController.text.isEmpty) {
      _partsController.text = wordData.parts ?? '';
    }
  }

  void _onSentenceSelected(String suggestion) {
    _sentenceController.text = suggestion;
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Detail> word = _getWordData();
    final OutputDetailNotifier service = _getService();

    return word.when(
      data: (wordData) {
        _updateControllersIfNotEditing(wordData);
        return _buildWordDetailScaffold(context, wordData, service);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.eventError(err))),
    );
  }

  void _updateControllersIfNotEditing(Detail word) {
    if (!_isEditing) {
      _chineseController.text = word.chinese ?? '';
      _definitionController.text = word.definition ?? '';
      _partsController.text = word.parts ?? '';
      _sentenceController.text = word.sentence ?? '';
    }
  }

  Widget _buildWordDetailScaffold(
    BuildContext context, 
    Detail word, 
    OutputDetailNotifier service,
  ) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context, word, service),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
        onPressed: () => Navigator.pop(context),
      ),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    final log = AppLocalizations.of(context)!;
    if (_isEditing) {
      return [
        IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
          onPressed: _cancelEdit,
          tooltip: log.eventCancel,
        ),
        IconButton(
          icon: Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
          onPressed: () => _saveChanges(_getWordData().value!, _getService()),
          tooltip: log.eventSave,
        ),
        const SizedBox(width: 8),
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.onSurface),
          onPressed: _toggleEditMode,
          tooltip: log.eventEdit,
        ),
        const SizedBox(width: 8),
      ];
    }
  }

 Widget _buildBody(BuildContext context, Detail word, OutputDetailNotifier service) {
  final bool isNoDefWord = _isNoDefinitionWord(word);
  
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surfaceContainerLowest,
        ],
      ),
    ),
    child: ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        _buildMainWordCard(word, isNoDefWord),
        const SizedBox(height: 20),
        if (!isNoDefWord || _isEditing) ...[
          _buildExamplesCard(word),
          const SizedBox(height: 20),
        ],
        if (!isNoDefWord || _isEditing) ...[
          _buildLabelsCard(word, service, isNoDefWord),
          const SizedBox(height: 20),
        ],
        if (isNoDefWord && !_isEditing) _buildNoDefinitionPrompt(),
        const SizedBox(height: 32),
      ],
    ),
  );
}

  Widget _buildNoDefinitionPrompt() {
    final log = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit_note,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              log.wordHasnodef,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              log.buttontoEdit,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _toggleEditMode,
              icon: const Icon(Icons.add, size: 20),
              label: Text(log.addDefinition),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWordCard(Detail word, bool isNoDefWord) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWordHeader(word, isNoDefWord),
            if (!isNoDefWord || _isEditing) ...[
              const SizedBox(height: 16),
              _buildPartOfSpeechRow(word),
              const SizedBox(height: 20),
              _buildDefinitionSection(word),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWordHeader(Detail word, bool isNoDefWord) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildEnglishWordSection(word),
        const SizedBox(width: 8),
        if (!isNoDefWord || _isEditing) _buildChineseTranslationSection(word),
      ],
    );
  }

  Widget _buildEnglishWordSection(Detail word) {
    return Expanded(
      flex: 3,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            word.name,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
    );
  }

  Widget _buildChineseTranslationSection(Detail word) {
    return Expanded(
      flex: 2,
      child: Center(
        child: _isEditing
            ? _buildChineseTextField()
            : _buildChineseText(word),
      ),
    );
  }

  Widget _buildChineseTextField() {
    final log = AppLocalizations.of(context)!;
    return TextField(
      controller: _chineseController,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
        labelText: log.chinese,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)),
        hintText: log.addTranslate,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildChineseText(Detail word) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(bottom: 4),
        child: Text(
          word.chinese ?? '',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }

  Widget _buildPartOfSpeechRow(Detail word) {
    return Row(
      children: [
        _buildSectionLabel(AppLocalizations.of(context)!.definition),
        const SizedBox(width: 8),
        Expanded(child: _buildPartOfSpeechField(word)),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  Widget _buildPartOfSpeechField(Detail word) {
    if (_isEditing) {
      return TextField(
        controller: _partsController,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
          labelText: AppLocalizations.of(context)!.partsOfSpeech,
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)),
          hintText: 'e.g., noun, verb, adjective',
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          word.parts ?? '',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      );
    }
  }

  Widget _buildDefinitionSection(Detail word) {
    final log = AppLocalizations.of(context)!;
    final nodictTextField = TextField(
          controller: _definitionController,
          maxLines: 3,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            height: 1.4,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
            labelText: log.definition,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)),
            hintText: log.enterDefinition,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5)),
            contentPadding: const EdgeInsets.all(16),
          ),
          onTap: _onTapDefinitionField,
        );

    if (_isEditing) {
      if (!_showDefinitionSuggestions) {
        // 尚未點擊輸入框，不要載入建議資料，直接顯示一般 TextField
        return nodictTextField;
      } else {
        // 使用者點擊後才 watch provider 載入建議
        final suggestionsAsync = ref.watch(outputDictNotifierProvider(widget.wordName));

        return suggestionsAsync.when(
          data: (suggestions) => SuggestionTextField(
            controller: _definitionController,
            maxLines: 3,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              height: 1.4,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
              labelText: log.definition,
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7)),
              hintText: log.enterDefinition,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.5)),
              contentPadding: const EdgeInsets.all(16),
            ),
            label: log.definition,
            suggestions: suggestions,
            onTap: _onTapDefinitionField,
            onSelected: _onDefinitionSelected,
          ),
          loading: () => const CircularProgressIndicator(),
          error: (e, _) {
            // 先在下一幀顯示 SnackBar，再回退到普通輸入框
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(log.apiLoadFail)),
              );
            });
            return nodictTextField;
          },
        );
      }
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          word.definition ?? '',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            height: 1.4,
          ),
        ),
      );
    }
  }

  Widget _buildExamplesCard(Detail word) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel(AppLocalizations.of(context)!.example),
            const SizedBox(height: 20),
            _buildExampleSentenceRow(word),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleSentenceRow(Detail word) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        if (!_isEditing) _buildBulletPoint(),
        if (!_isEditing) const SizedBox(width: 12),
        Expanded(child: _buildExampleSentenceField(word)),
      ],
    );
  }

  Widget _buildBulletPoint() {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildExampleSentenceField(Detail word) {
    final log = AppLocalizations.of(context)!;
    final nodictTextField = TextField(
          controller: _sentenceController,
          maxLines: 3,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            height: 1.5,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
            labelText: log.exampleSentence,
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
            hintText: log.enterSentence,
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            contentPadding: const EdgeInsets.all(16),
          ),
          onTap: _onTapSentenceField,
        );

    if (_isEditing) {
      if (!_showSentenceSuggestions) {
        return nodictTextField;
      } else {
        final suggestionsAsync = ref.watch(outputDictNotifierProvider(widget.wordName));

        return suggestionsAsync.when(
          data: (suggestions) => SuggestionTextField(
            controller: _sentenceController,
            maxLines: 3,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              labelText: log.exampleSentence,
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
              hintText: log.enterSentence,
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
              contentPadding: const EdgeInsets.all(16),
            ),
            label: log.exampleSentence,
            suggestions: suggestions,
            onTap: _onTapSentenceField,
            onSelected: _onSentenceSelected,
          ),
          loading: () => const CircularProgressIndicator(),
          error: (e, _) {
            // 先在下一幀顯示 SnackBar，再回退到普通輸入框
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(log.apiLoadFail)),
              );
            });
            return nodictTextField;
          },
        );
      }
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          word.sentence ?? '',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            height: 1.5,
          ),
        ),
      );
    }
  }

  Widget _buildLabelsCard(Detail word, OutputDetailNotifier service, bool isNoDefWord) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelsHeader(service, word, isNoDefWord),
            const SizedBox(height: 20),
            _buildLabelsWrap(word, service),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelsHeader(OutputDetailNotifier service, Detail word, bool isNoDefWord) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            AppLocalizations.of(context)!.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
        ),
        if (_isEditing) ...[
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: isNoDefWord ? Theme.of(context).colorScheme.outline : Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            onPressed: isNoDefWord 
              ? () => _showNoDefWarning() // Show warning if isNoDef is true
              : () => _showAddLabelDialog(context, service, word.labels, word.id),
          ),
        ],
      ],
    );
  }

  // New method to show warning when trying to add labels to NoDefinition word
  void _showNoDefWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.nodefWarning),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _buildLabelsWrap(Detail word, OutputDetailNotifier service) {
    final log = AppLocalizations.of(context)!;
    if(word.labels == null || word.labels!.isEmpty) {
      return _isEditing 
        ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isNoDef 
                ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.3)
                : Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _isNoDef 
                ? log.addLabelHint
                : log.noLabelHint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _isNoDef 
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          )
        : const SizedBox.shrink();
    }
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: word.labels!
          .map((tag) => _buildTagChip(tag, _isEditing, service, widget.wordId))
          .toList(),
    );
  }

  Widget _buildTagChip(
    LabelItem label, 
    bool isEditing, 
    OutputDetailNotifier service, 
    int wordId,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.name,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isEditing) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _removeLabel(service, wordId, label.id),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _removeLabel(OutputDetailNotifier service, int wordId, int labelId) {
   service.removeWordFromLabel(wordId, labelId);
  } 

  void _showAddLabelDialog(
    BuildContext context, 
    OutputDetailNotifier service, 
    List<LabelItem>? inWordLabelList,
    int wordId
  ) async {
    final log = AppLocalizations.of(context)!;
  try {
    final List<LabelItem> labelList = await service.getAddLabel();
    
    if (!context.mounted) return;
    
    // Create local state for this dialog session
    final Map<int, bool> selectedLabels = {};
    
    // Initialize with current word's labels
    for (var label in labelList) {
      selectedLabels[label.id] = inWordLabelList?.any((inLabel) => inLabel.id == label.id) ?? false;
    }
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(log.manageLabel),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: labelList.length,
              itemBuilder: (context, index) {
                final item = labelList[index];
                return labelWidget(
                  context, 
                  item, 
                  service, 
                  selectedLabels, 
                  setDialogState
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(log.eventCancel),
            ),
            TextButton(
              onPressed: () => _processLabelChanges(service, wordId, inWordLabelList, selectedLabels),
              child: Text(log.eventOk),
            ),
          ],
        ),
      ),
    );
  } catch (error) {
    if (!context.mounted) return;
    
    // Show error dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(log.eventError('')),
        content: Text(log.loadLabelFail(error)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(log.eventOk),
          ),
        ],
      ),
    );
  }
}

// 6. Updated labelWidget to work with local state
Widget labelWidget(
  BuildContext context, 
  LabelItem item, 
  OutputDetailNotifier service,
  Map<int, bool> selectedLabels,
  StateSetter setDialogState,
) {
  return CheckboxListTile(
    title: Text(
      item.name,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    ),
    value: selectedLabels[item.id] ?? false,
    onChanged: (bool? value) {
      setDialogState(() {
        selectedLabels[item.id] = value ?? false;
      });
    },
    checkColor: Theme.of(context).colorScheme.onPrimary,
    activeColor: Theme.of(context).colorScheme.primary,
    controlAffinity: ListTileControlAffinity.leading,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

  // 新增函數：處理標籤變更
  void _processLabelChanges(
  OutputDetailNotifier service, 
  int wordId, 
  List<LabelItem>? originalLabels,
  Map<int, bool> selectedLabels, // Add this parameter
  ) {
  // Get original label state
  Set<int> originalLabelIds = originalLabels?.map((label) => label.id).toSet() ?? {};
  
  // Process each label change
  selectedLabels.forEach((labelId, isSelected) {
    bool wasSelected = originalLabelIds.contains(labelId);
    
    if (isSelected && !wasSelected) {
      // Need to add this label
      service.addWordToLabel(wordId, labelId);
    } else if (!isSelected && wasSelected) {
      // Need to remove this label
      service.removeWordFromLabel(wordId, labelId);
    }
  });
  
  Navigator.pop(context);
}

// Fixed updateWord function - now returns Future to handle async operation
Future<void> updateWord(Detail updateWord, OutputDetailNotifier service, bool isNodef) async {
  // Check if any fields have content to determine if we should convert NoDefinition to Word
  bool hasContent = (updateWord.definition?.isNotEmpty ?? false) ||
                   (updateWord.chinese?.isNotEmpty ?? false) ||
                   (updateWord.parts?.isNotEmpty ?? false) ||
                   (updateWord.sentence?.isNotEmpty ?? false);
  
  // Only update fields if they have content or if it's already a Word type (not NoDefinition)
  if (hasContent || !isNodef) {
    service.modifyDetail('definition', updateWord.definition ?? '');
    service.modifyDetail('parts', updateWord.parts ?? '');
    service.modifyDetail('chinese', updateWord.chinese ?? '');
    service.modifyDetail('sentence', updateWord.sentence ?? '');
  }
  
  // This is where the database type change happens (NoDef -> Word)
  // Make sure this completes before returning
  await service.storeDetail();
}

}