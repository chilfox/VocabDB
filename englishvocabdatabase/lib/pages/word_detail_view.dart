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

  WordDetailView({
    super.key,
    required this.label,
    required this.wordId,
    required this.startWithEditView,
  });

  @override
  ConsumerState<WordDetailView> createState() => _WordDetailView();
}

class _WordDetailView extends ConsumerState<WordDetailView> {
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
        return wordDetail(context, word, service);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
 }
}

Widget wordDetail(BuildContext context, final Detail word, final OutputDetailNotifier service) {
  String englishVocabulary = word.name;
  String chineseTranslation = word.chinese ?? '';
  String englishDefinition = word.definition ?? '';
  String partOfSpeech = word.parts ?? '';
  String exampleSentence = word.sentence ?? '';

  return Scaffold(
    appBar: AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        // activate edit button
        IconButton(
          icon: const Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {
            // Add bookmark functionality
          },
        ),
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
                      // english
                      Expanded(
                        child: Text(
                          englishVocabulary,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // chinese
                      Expanded(
                        child: Center(
                          child: Text(
                            chineseTranslation,
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
                        child: Text(
                          'Definition',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Text(
                        partOfSpeech,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Chinese translation
                  Text(
                    '  $englishDefinition',
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
                  
                  // English example
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exampleSentence,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  //const SizedBox(height: 16),
                  
                  // Chinese example translation
                  /*
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '安坐在我們前面兩排的位置。', // This would be dynamic
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  */
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Definition section
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
                  // Definition header
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
                  const SizedBox(height: 16),
                  
                  // English definition
                  Wrap(
                    spacing: 8.0, // 子 Widget 之間水平間距
                    runSpacing: 8.0, // 行與行之間垂直間距
                    children: word.labels!.map((tag) {
                      return _buildTagChip(tag);
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

Widget _buildTagChip(LabelItem label) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    decoration: BoxDecoration(
      color: , // 標籤背景色
      borderRadius: BorderRadius.circular(20.0), // 圓角
    ),
    child: Text(
      label.name,
      style: const TextStyle(
        color: Colors.white, // 文字顏色
        fontSize: 14.0,
      ),
    ),
  );
}

// Example usage:
/*
VocabularyDetailPage(
  englishVocabulary: "ahead",
  chineseTranslation: "向前",
  englishDefinition: "If you want to get ahead as a student, you should study wisely.",
  partOfSpeech: "adv.",
  exampleSentence: "Ann sat two rows ahead of us.",
  pronunciation: "/əˈhed/",
)
*/