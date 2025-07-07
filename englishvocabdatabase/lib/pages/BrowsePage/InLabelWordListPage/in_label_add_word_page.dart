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
        SnackBar(content: Text(AppLocalizations.of(context)!.eventNoSelectWord)),
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
        SnackBar(content: Text(AppLocalizations.of(context)!.doneWordToLabel(successCount))),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.wordToLabelFail(successCount, selectedWordIds.length))),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Word, inlabel: false, labelId: widget.label.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addWordBar, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
        centerTitle: false,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              //search bar
              InLabelAddWordSearchBar(label: widget.label),

              asyncList.when(
                data: (list) {
                  if (list.isEmpty){
                    return Expanded(child: Center(child: Text(AppLocalizations.of(context)!.wordListEmpty)));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final word = list[index];
                        return CheckBoxWordWidget(
                          word: word,
                          onSelectionChanged: _onWordSelectionChanged,
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text(AppLocalizations.of (context)!.eventError(err))
                )
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: selectedWordIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _addSelectedWordsToLabel,
              label: Text(AppLocalizations.of(context)!.done),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
