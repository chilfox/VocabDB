import 'package:englishvocabdatabase/pages/BrowsePage/label_list_view.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/search_bar.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/word_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/language/generated/app_localizations.dart';

enum ChooseListView { word, label, nodef }

final wordBankViewProvider = StateProvider<ChooseListView>((ref) {
  return ChooseListView.label;
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
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Enhanced search bar with Material 3 styling
            const MySearchBar(),

            const SizedBox(height: 24.0), // Increased spacing for better visual rhythm
            
            // Modern segmented button for view selection (label vs word)
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 5),
              child: SegmentedButton<ChooseListView>(
                segments: [
                  ButtonSegment(
                    value: ChooseListView.label,
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  ButtonSegment(
                    value: ChooseListView.word,
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        AppLocalizations.of(context)!.word,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
            
                selected: <ChooseListView>{currentView},
            
                onSelectionChanged: (Set<ChooseListView> newSelection) {
                  ref.read(wordBankViewProvider.notifier).state = newSelection.first;
                },
                
                showSelectedIcon: false,
                // Material 3 theming for segmented button
                style: SegmentedButton.styleFrom(
                  backgroundColor: theme.colorScheme.surface,
                  foregroundColor: theme.colorScheme.onSurface,
                  selectedBackgroundColor: theme.colorScheme.secondaryContainer,
                  selectedForegroundColor: theme.colorScheme.onSecondaryContainer,
                  side: BorderSide(color: theme.colorScheme.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            // Dynamic content display based on current view
            // Labels use card-based design, words use list-based design
            Expanded(
              child: currentView == ChooseListView.label 
                ? const LabelListView() 
                : const WordListView(),
            ),
          ],
        ),
      ),
    );
  }
}