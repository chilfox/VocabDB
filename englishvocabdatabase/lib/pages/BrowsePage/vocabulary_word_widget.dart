import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/pages/word_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:englishvocabdatabase/language/generated/app_localizations.dart';

/// Word widget with distinct design from label widgets
/// Uses list-based layout with circular icons and dividers
/// Provides visual distinction from card-based label design
class VocabularyWordWidget extends StatelessWidget {
  final OutputListItem item;
  final OutputListNotifier service;
  
  const VocabularyWordWidget({super.key, required this.item, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Word widget uses a different design pattern than labels
    // Uses ListTile-based design with dividers for distinction from card-based labels
    return Slidable(
      // Unique key for each word item
      key: ValueKey(item.id),
    
      // Swipe-to-delete functionality with smooth animation
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) async {
              bool success = await service.delete(item.id);
              if (!context.mounted) return;
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.eventDeleteFail),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete_outline,
          ),
        ],
      ),
      child: Column(
        children: [
          // Word item container with distinct styling from labels
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // Subtle rounded corners for touch feedback
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WordDetailView(
                      label: null, 
                      wordId: item.id, 
                      wordName: item.name, 
                      startWithEditView: false, 
                      nodef: false,
                    )),
                  );
                },
                child: Container(
                  constraints: const BoxConstraints(minHeight: 72.0), // Slightly taller than labels
                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
                  child: Row(
                    children: [
                      // Word icon indicator (different from labels' colored bar)
                      // Uses circular container with icon instead of rectangular bar
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(20.0), // Circular instead of rectangular
                        ),
                        child: Icon(
                          Icons.text_fields_rounded, // Text icon to represent words
                          color: theme.colorScheme.onSecondaryContainer,
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Word name with distinct typography from labels
                            Text(
                              item.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w500, // Lighter weight than labels
                                letterSpacing: 0.5, // Slightly spaced for readability
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Chinese translation with muted styling
                            if (item.chinese != null && item.chinese!.isNotEmpty) ...[
                              const SizedBox(height: 6.0),
                              Text(
                                item.chinese!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontStyle: FontStyle.italic, // Italic for distinction
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Simple arrow icon (different from labels' chevron)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 16.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Divider for separation (labels don't have this)
          // Provides visual separation between words in the list
          Container(
            margin: const EdgeInsets.only(left: 72.0), // Indented to align with text
            child: Divider(
              height: 1.0,
              thickness: 0.5,
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}