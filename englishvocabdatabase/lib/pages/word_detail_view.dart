import 'package:englishvocabdatabase/logic/output/outputDetailItem.dart';
import 'package:englishvocabdatabase/logic/output/outputDetailNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordDetailView extends ConsumerStatefulWidget {
  final OutputListItem? label;
  final int wordId;
  final bool startWithEditView;

  const WordDetailView({
    super.key,
    required this.label,
    required this.wordId,
    required this.startWithEditView,
  });

  @override
  ConsumerState<WordDetailView> createState() => _WordDetailView();
}

class _WordDetailView extends ConsumerState<WordDetailView> {
  bool _isEditing = false;
  
  // Text editing controllers
  late TextEditingController _nameController;
  late TextEditingController _chineseController;
  late TextEditingController _definitionController;
  late TextEditingController _partsController;
  late TextEditingController _sentenceController;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.startWithEditView;
    
    // Initialize controllers
    _nameController = TextEditingController();
    _chineseController = TextEditingController();
    _definitionController = TextEditingController();
    _partsController = TextEditingController();
    _sentenceController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _chineseController.dispose();
    _definitionController.dispose();
    _partsController.dispose();
    _sentenceController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges(Detail word, OutputDetailNotifier service) {
    // Create updated word object
    final updatedWord = Detail(
      id: word.id,
      name: _nameController.text,
      chinese: _chineseController.text,
      definition: _definitionController.text,
      parts: _partsController.text,
      sentence: _sentenceController.text,
      labels: word.labels, // Keep existing labels for now
    );
    
    // Call service to save changes
    updateWord(updatedWord, service);
    
    // Exit edit mode
    _toggleEditMode();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Word updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _cancelEdit() {
    // Reset controllers to original values
    _toggleEditMode();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Detail> word;
    final OutputDetailNotifier service;
    if(widget.wordId == -1){
      word = ref.watch(outputDetailNotifierProvider(DetailType.NodefDetail, widget.wordId));
      service = ref.read(outputDetailNotifierProvider(DetailType.NodefDetail, widget.wordId).notifier);
    }
    else{
      word = ref.watch(outputDetailNotifierProvider(DetailType.WordDetail, widget.wordId));
      service = ref.watch(outputDetailNotifierProvider(DetailType.WordDetail, widget.wordId).notifier);
    }

    return word.when(
      data: (word){
        // Update controllers when data is loaded
        if (!_isEditing) {
          _nameController.text = word.name;
          _chineseController.text = word.chinese ?? '';
          _definitionController.text = word.definition ?? '';
          _partsController.text = word.parts ?? '';
          _sentenceController.text = word.sentence ?? '';
        }
        
        return wordDetail(context, word, service);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget wordDetail(BuildContext context, final Detail word, final OutputDetailNotifier service) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Edit/Save button
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: _cancelEdit,
              tooltip: 'Cancel',
            ),
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () => _saveChanges(word, service),
              tooltip: 'Save',
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: _toggleEditMode,
              tooltip: 'Edit',
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*
            Main Word Card
            */
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        // English word
                        Expanded(
                          child: _isEditing
                              ? TextField(
                                  controller: _nameController,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'English Word',
                                    labelStyle: TextStyle(color: Colors.white70),
                                  ),
                                )
                              : Text(
                                  word.name,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        // Chinese translation
                        Expanded(
                          child: Center(
                            child: _isEditing
                                ? TextField(
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
                                    ),
                                  )
                                : Text(
                                    word.chinese ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Part of speech
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Definition',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _isEditing
                              ? TextField(
                                  controller: _partsController,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Part of Speech',
                                    labelStyle: TextStyle(color: Colors.white70),
                                  ),
                                )
                              : Text(
                                  word.parts ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Definition
                    if (_isEditing)
                      TextField(
                        controller: _definitionController,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Definition',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                      )
                    else
                      Text(
                        '  ${word.definition ?? ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Examples section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Examples header
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Example',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Example sentence
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 8,),
                        if (!_isEditing)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                        if (!_isEditing) const SizedBox(width: 12),
                        Expanded(
                          child: _isEditing
                              ? TextField(
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
                                  ),
                                )
                              : Text(
                                  word.sentence ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    height: 1.4,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Labels section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Labels header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
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
                            onPressed: () {
                              // Add functionality to add new labels
                              _showAddLabelDialog(context, service, word.id);
                            },
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Labels
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: word.labels!.map((tag) {
                        return _buildTagChip(tag, _isEditing, service, widget.wordId);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(LabelItem label, bool isEditing, OutputDetailNotifier service, int wordId) {
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
              onTap: () {
                setState(() {
                  // Remove from labels list
                  service.removeWordFromLabel(wordId, label.id);
                });
              },
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

  void _showAddLabelDialog(BuildContext context, OutputDetailNotifier service, int wordId) {
    final TextEditingController labelController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Label'),
        content: TextField(
          controller: labelController,
          decoration: const InputDecoration(
            hintText: 'Enter label name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (labelController.text.isNotEmpty) {
                int labelId = 1;
                service.addWordToLabel(wordId, labelId);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

void updateWord(Detail updateWord, OutputDetailNotifier service){
  service.modifyDetail('name', updateWord.name);
  service.modifyDetail('definition', updateWord.definition ?? '');
  service.modifyDetail('parts', updateWord.parts ?? '');
  service.modifyDetail('chinese', updateWord.chinese ?? '');
  service.modifyDetail('sentence', updateWord.sentence ?? '');
  service.storeDetail();
}