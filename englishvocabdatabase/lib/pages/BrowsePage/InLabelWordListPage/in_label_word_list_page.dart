import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/in_label_add_word_page.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/in_label_search_bar.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/vocabulary_word_widget.dart';
import '../../../logic/output/outputListNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InLabelWordListPage extends ConsumerStatefulWidget {
  final OutputListItem label;

  const InLabelWordListPage({super.key, required this.label});

  @override
  ConsumerState<InLabelWordListPage> createState() => _InLabelWordListPage();
}
class _InLabelWordListPage extends ConsumerState<InLabelWordListPage> {
  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Word, inlabel: true, labelId: widget.label.id));
    final service = ref.read(outputListNotifierProvider(NotifierType.Word, inlabel: true, labelId: widget.label.id).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
        centerTitle: false,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              InLabelSearchBar(label: widget.label,),
              
              asyncList.when(
                data: (list) {
                  if (list.isEmpty){
                    return Expanded(child: const Center(child: Text("Word List is Empty")));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return VocabularyWordWidget(item: item, service: service);
                      },
                    ),
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
            MaterialPageRoute(builder: (context) => InLabelAddWordPage(label: widget.label)),
          );
        },
        label: const Text('Add Word'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}