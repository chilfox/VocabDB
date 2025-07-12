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

    // Get theme data for consistent Material 3 styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return asyncList.when(
      data: (list) {
        if (list.isEmpty){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.library_books_outlined,
                  size: 64.0,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16.0),
                Text(
                  AppLocalizations.of(context)!.wordListEmpty,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
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