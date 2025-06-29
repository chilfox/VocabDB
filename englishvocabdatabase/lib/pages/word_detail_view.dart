import 'package:englishvocabdatabase/logic/output/outputDetailItem.dart';
import 'package:englishvocabdatabase/logic/output/outputDetailNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordDetailView extends ConsumerStatefulWidget {
  final OutputListItem? label;
  final int wordId;
  final bool startWithEditView;
  final bool nodef; // 新增參數

  const WordDetailView({
    super.key,
    required this.label,
    required this.wordId,
    required this.startWithEditView,
    required this.nodef, // 新增必要參數
  });

  @override
  ConsumerState<WordDetailView> createState() => _WordDetailViewState();
}

class _WordDetailViewState extends ConsumerState<WordDetailView> {
  bool _isEditing = false;
  
  // Text editing controllers
  late final TextEditingController _chineseController;
  late final TextEditingController _definitionController;
  late final TextEditingController _partsController;
  late final TextEditingController _sentenceController;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.startWithEditView;
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

  void _saveChanges(Detail word, OutputDetailNotifier service) {
    final updatedWord = _createUpdatedWord(word);
    _updateWordInService(updatedWord, service);
    _exitEditMode();
    _showSuccessMessage();
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

  void _updateWordInService(Detail updatedWord, OutputDetailNotifier service) {
    updateWord(updatedWord, service, widget.nodef); // 傳入 nodef 參數
  }

  void _exitEditMode() {
    _toggleEditMode();
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Word updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelEdit() {
    _toggleEditMode();
  }

  AsyncValue<Detail> _getWordData() {
    final detailType = widget.nodef // 使用 nodef 參數判斷
        ? DetailType.NodefDetail 
        : DetailType.WordDetail;
    return ref.watch(outputDetailNotifierProvider(detailType, widget.wordId));
  }

  OutputDetailNotifier _getService() {
    final detailType = widget.nodef // 使用 nodef 參數判斷
        ? DetailType.NodefDetail 
        : DetailType.WordDetail;
    return ref.watch(outputDetailNotifierProvider(detailType, widget.wordId).notifier);
  }

  // Helper method to check if this is a NoDefinition word (only has id and name)
  bool _isNoDefinitionWord(Detail word) {
    return widget.nodef && 
           (word.definition == null || word.definition!.isEmpty) &&
           (word.chinese == null || word.chinese!.isEmpty) &&
           (word.parts == null || word.parts!.isEmpty) &&
           (word.sentence == null || word.sentence!.isEmpty);
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
      error: (err, stack) => Center(child: Text('Error: $err')),
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isEditing) {
      return [
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: _cancelEdit,
          tooltip: 'Cancel',
        ),
        IconButton(
          icon: const Icon(Icons.check, color: Colors.white),
          onPressed: () => _saveChanges(_getWordData().value!, _getService()),
          tooltip: 'Save',
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: _toggleEditMode,
          tooltip: 'Edit',
        ),
      ];
    }
  }

 Widget _buildBody(BuildContext context, Detail word, OutputDetailNotifier service) {
  final bool isNoDefWord = _isNoDefinitionWord(word);
  
  return ListView(
    padding: const EdgeInsets.all(16.0),
    children: [
      _buildMainWordCard(word, isNoDefWord),
      const SizedBox(height: 16),
      if (!isNoDefWord || _isEditing) ...[
        _buildExamplesCard(word),
        const SizedBox(height: 16),
      ],
      if (!isNoDefWord || _isEditing) ...[
        _buildLabelsCard(word, service),
        const SizedBox(height: 16),
      ],
      if (isNoDefWord && !_isEditing) _buildNoDefinitionPrompt(),
      const SizedBox(height: 20),
    ],
  );
}

  Widget _buildNoDefinitionPrompt() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.edit_note,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'This word has no definition yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the edit button to add definition, translation, and more details',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _toggleEditMode,
              icon: const Icon(Icons.add),
              label: const Text('Add Definition'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainWordCard(Detail word, bool isNoDefWord) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWordHeader(word, isNoDefWord),
            if (!isNoDefWord || _isEditing) ...[
              const SizedBox(height: 8),
              _buildPartOfSpeechRow(word),
              const SizedBox(height: 16),
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
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
    return TextField(
      controller: _chineseController,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Chinese',
        labelStyle: TextStyle(color: Colors.white70),
        hintText: 'Add translation',
        hintStyle: TextStyle(color: Colors.white54),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
        _buildSectionLabel('Definition'),
        const SizedBox(width: 8),
        Expanded(child: _buildPartOfSpeechField(word)),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPartOfSpeechField(Detail word) {
    if (_isEditing) {
      return TextField(
        controller: _partsController,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Part of Speech',
          labelStyle: TextStyle(color: Colors.white70),
          hintText: 'e.g., noun, verb, adjective',
          hintStyle: TextStyle(color: Colors.white54),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          word.parts ?? '',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  Widget _buildDefinitionSection(Detail word) {
    if (_isEditing) {
      return TextField(
        controller: _definitionController,
        maxLines: 3,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Definition',
          labelStyle: TextStyle(color: Colors.white70),
          hintText: 'Enter word definition',
          hintStyle: TextStyle(color: Colors.white54),
        ),
      );
    } else {
      return Text(
        '  ${word.definition ?? ''}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }
  }

  Widget _buildExamplesCard(Detail word) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('Example'),
            const SizedBox(height: 16),
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
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildExampleSentenceField(Detail word) {
    if (_isEditing) {
      return TextField(
        controller: _sentenceController,
        maxLines: 3,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          height: 1.4,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Example Sentence',
          hintText: 'Enter an example sentence',
          hintStyle: TextStyle(color: Colors.white54),
        ),
      );
    } else {
      return Text(
        word.sentence ?? '',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          height: 1.4,
        ),
      );
    }
  }

  Widget _buildLabelsCard(Detail word, OutputDetailNotifier service) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelsHeader(service, word.id),
            const SizedBox(height: 16),
            _buildLabelsWrap(word, service),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelsHeader(OutputDetailNotifier service, int wordId) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            'Labels',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (_isEditing) ...[
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.blue),
            onPressed: () => _showAddLabelDialog(context, service, wordId),
          ),
        ],
      ],
    );
  }

  Widget _buildLabelsWrap(Detail word, OutputDetailNotifier service) {
    if(word.labels == null || word.labels!.isEmpty) {
      return _isEditing 
        ? const Text(
            'No labels yet. Add some to organize your words!',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          )
        : const SizedBox.shrink();
    }
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          if (isEditing) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _removeLabel(service, wordId, label.id),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _removeLabel(OutputDetailNotifier service, int wordId, int labelId) {
    setState(() {
      service.removeWordFromLabel(wordId, labelId);
    });
  }

  void _showAddLabelDialog(
    BuildContext context, 
    OutputDetailNotifier service, 
    int wordId,
  ) {
    final TextEditingController labelController = TextEditingController(); 
    final asyncList = service.
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Labels'),
        content: asyncList.when(
          data: (list) {
            if (list.isEmpty){
              return const Center(child: Text("Label List is Empty"));
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return labelCheckboxWidget(context, item, ref.read(outputListNotifierProvider(NotifierType.Label).notifier));
              },
            )
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _addLabel(labelController, service, wordId),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addLabel(
    TextEditingController labelController, 
    OutputDetailNotifier service, 
    int wordId,
  ) {
    if (labelController.text.isNotEmpty) {
      const int labelId = 1;
      service.addWordToLabel(wordId, labelId);
      Navigator.pop(context);
    }
  }
}

void updateWord(Detail updateWord, OutputDetailNotifier service, bool isNodef) {
  // Check if any fields have content to determine if we should convert NoDefinition to Word
  bool hasContent = (updateWord.definition?.isNotEmpty ?? false) ||
                   (updateWord.chinese?.isNotEmpty ?? false) ||
                   (updateWord.parts?.isNotEmpty ?? false) ||
                   (updateWord.sentence?.isNotEmpty ?? false);

  service.modifyDetail('name', updateWord.name);
  
  // Only update fields if they have content or if it's already a Word type
  if (hasContent || !isNodef) {
    service.modifyDetail('definition', updateWord.definition ?? '');
    service.modifyDetail('parts', updateWord.parts ?? '');
    service.modifyDetail('chinese', updateWord.chinese ?? '');
    service.modifyDetail('sentence', updateWord.sentence ?? '');
  }
  
  service.storeDetail();
}