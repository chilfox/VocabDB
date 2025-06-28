import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/in_label_search_bar.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/vocabulary_word_widget.dart';
import 'package:englishvocabdatabase/pages/word_detail_view.dart';
import '../../../logic/output/outputListNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InLabelWordListPage extends ConsumerWidget {
  final OutputListItem label;
  
  const InLabelWordListPage({super.key, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Word));
    final service = ref.read(outputListNotifierProvider(NotifierType.Word).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(label.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
        centerTitle: false,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              InLabelSearchBar(label: label,),
              
              asyncList.when(
                data: (list) {
                  if (list.isEmpty){
                    return Expanded(child: const Center(child: Text("Word List is Empty")));
                  }
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return VocabularyWordWidget(item: item, service: service);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WordDetailView(label: label, wordId: -1, startWithEditView: true,)),
          );
        },
        label: const Text('Add Word'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}