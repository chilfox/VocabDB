import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/vocabulary_word_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordListView extends ConsumerStatefulWidget {
  const WordListView({super.key});

  @override
  ConsumerState<WordListView> createState() => _WordListViewState();
}

class _WordListViewState extends ConsumerState<WordListView> {
  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Word));
    final service = ref.read(outputListNotifierProvider(NotifierType.Word).notifier);

    return asyncList.when(
      data: (list) {
        if (list.isEmpty){
          return Center(child: Text(AppLocalizations.of(context)!.wordListEmpty));
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
      error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.eventError(err))),
    );
  }
}