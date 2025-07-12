import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/in_label_add_word_page.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/in_label_search_bar.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/in_label_vocabulary_word_widget.dart';
import '../../../logic/output/outputListNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/background/container.dart';

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
    final theme = Theme.of(context);

    return BackgroundScaffold(
      appBar: AppBar(
        title: Text(
          widget.label.name, 
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: InLabelSearchBar(label: widget.label),
            ),
            
            // Word list
            Expanded(
              child: asyncList.when(
                data: (list) {
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.text_fields_rounded,
                            size: 64.0,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            AppLocalizations.of(context)!.wordListEmpty,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 88.0), // Bottom padding for FAB
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final item = list[index];
                      return InLabelVocabularyWordWidget(
                        word: item, 
                        label: widget.label, 
                        service: service,
                      );
                    },
                  );
                },
                loading: () => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Loading words...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.0,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        AppLocalizations.of(context)!.eventError(err),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: widget.label.id == 1
        ? null
        : FloatingActionButton.extended(
            onPressed: () async{
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InLabelAddWordPage(label: widget.label)),
              );
              final _ = ref.refresh(outputListNotifierProvider(NotifierType.Word, inlabel: true, labelId: widget.label.id));
            },
            label: Text(AppLocalizations.of(context)!.addWordBar),
            icon: const Icon(Icons.add),
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: theme.colorScheme.onPrimaryContainer,
            elevation: 3.0,
          ),
    );
  }
}