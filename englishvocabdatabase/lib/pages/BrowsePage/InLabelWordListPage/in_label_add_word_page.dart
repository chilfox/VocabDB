import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'in_label_add_word_search_bar.dart';
import 'checkbox_word_widget.dart';

class InLabelAddWordPage extends ConsumerStatefulWidget {
  final OutputListItem label;

  const InLabelAddWordPage({super.key, required this.label});

  @override
  ConsumerState<InLabelAddWordPage> createState() => _InLabelAddWordPageState();
}

class _InLabelAddWordPageState extends ConsumerState<InLabelAddWordPage> {
  final Set<int> selectedWordIds = <int>{};

  void _onWordSelectionChanged(int wordId, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedWordIds.add(wordId);
      } else {
        selectedWordIds.remove(wordId);
      }
    });
  }

  Future<void> _addSelectedWordsToLabel() async {
    if (selectedWordIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.eventNoSelectWord),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final service = ref.read(outputListNotifierProvider(NotifierType.Word, inlabel: false, labelId: widget.label.id).notifier);
    
    bool allSuccess = true;
    int successCount = 0;
    
    for (int wordId in selectedWordIds) {
      bool success = await service.addWordToLabel(wordId, widget.label.id);
      if (success) {
        successCount++;
      } else {
        allSuccess = false;
      }
    }

    if (!mounted) return;

    if (allSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.doneWordToLabel(successCount)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.wordToLabelFail(successCount, selectedWordIds.length)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Word, inlabel: false, labelId: widget.label.id));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.addWordBar, 
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        actions: selectedWordIds.isNotEmpty 
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text(
                      '${selectedWordIds.length}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primaryContainer,
                  ),
                ),
              ]
            : null,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
              child: InLabelAddWordSearchBar(label: widget.label),
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
                            Icons.search_off,
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
                      final word = list[index];
                      return CheckBoxWordWidget(
                        word: word,
                        onSelectionChanged: _onWordSelectionChanged,
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

      floatingActionButton: selectedWordIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _addSelectedWordsToLabel,
              label: Text(AppLocalizations.of(context)!.done),
              icon: const Icon(Icons.check),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 3.0,
            )
          : null,
    );
  }
}
