import 'package:englishvocabdatabase/pages/search_bar.dart';
import 'package:englishvocabdatabase/pages/word_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ChooseListView { word, label }

final wordBankViewProvider = StateProvider<ChooseListView>((ref) {
  return ChooseListView.word;
});

class WordBankPage extends ConsumerStatefulWidget {
  const WordBankPage({super.key});

  @override
  WordBankPageState createState() => WordBankPageState();
}

class WordBankPageState extends ConsumerState<WordBankPage> {

  @override
  Widget build(BuildContext context) {
    final currentView = ref.watch(wordBankViewProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            const MySearchBar(),

            const SizedBox(height: 20,),
            
            // choose view label list or word list
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 5),
                  child: SegmentedButton<ChooseListView>(
                    segments: const [
                      ButtonSegment(
                        value: ChooseListView.label,
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('Label'),
                        )
                      ),
                      ButtonSegment(
                        value: ChooseListView.word,
                        label: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text('Word'),
                        )
                      ),
                    ],
                
                    selected: <ChooseListView>{currentView},
                
                    onSelectionChanged: (Set<ChooseListView> newSelection) {
                      ref.read(wordBankViewProvider.notifier).state = newSelection.first;
                    },
                    
                    showSelectedIcon: false,
                  ),
                ),

                
              ],
            ),

            // show word list or label list based on currentView
            const Expanded(child: WordListView()),
          ],
        ),
      ),
    );
  }
}