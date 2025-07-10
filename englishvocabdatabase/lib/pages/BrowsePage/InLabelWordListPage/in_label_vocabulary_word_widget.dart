import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/pages/word_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class InLabelVocabularyWordWidget extends StatelessWidget {
  final OutputListItem word;
  final OutputListNotifier service;
  final OutputListItem label;
  
  const InLabelVocabularyWordWidget({super.key, required this.label, required this.word, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(12.0),
        color: theme.colorScheme.surface,
        child: Slidable(
          key: ValueKey(word.id),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) async {
                  bool success = await service.delete(word.id);
                  if (!context.mounted) return;
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.eventSearchFail),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                icon: Icons.delete_outline,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
            ],
          ),
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) {
                  service.removeWordFromLabel(word.id, label.id);
                },
                backgroundColor: theme.colorScheme.tertiary,
                foregroundColor: theme.colorScheme.onTertiary,
                icon: Icons.remove_circle_outline,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  bottomLeft: Radius.circular(12.0),
                ),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordDetailView(
                    label: null, 
                    wordId: word.id, 
                    wordName: word.name, 
                    startWithEditView: false, 
                    nodef: false,
                  ),
                ),
              );
            },
            child: Container(
              constraints: const BoxConstraints(minHeight: 72.0),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Word icon indicator
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Icon(
                      Icons.text_fields_rounded,
                      color: theme.colorScheme.onSecondaryContainer,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  
                  // Word content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Word name
                        Text(
                          word.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (word.chinese != null && word.chinese!.isNotEmpty) ...[
                          const SizedBox(height: 4.0),
                          // Chinese translation
                          Text(
                            word.chinese!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}