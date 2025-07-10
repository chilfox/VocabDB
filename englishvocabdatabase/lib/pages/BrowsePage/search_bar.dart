import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'word_bank_page.dart';
import '../../logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/language/generated/app_localizations.dart';


class MySearchBar extends ConsumerStatefulWidget {
  const MySearchBar({super.key});

  @override
  ConsumerState<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends ConsumerState<MySearchBar> {

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    final currentView = ref.watch(wordBankViewProvider);
    final theme = Theme.of(context);
    final String hintText;

    // Dynamic hint text based on current view mode
    if (currentView == ChooseListView.nodef){
      hintText = AppLocalizations.of(context)!.noDefSearchbar;
    }
    else{
      hintText = AppLocalizations.of(context)!.searchbar;
    }
    
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        // Modern rounded search icon
        prefixIcon: Icon(
          Icons.search_rounded,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        // Enhanced clear button with search reset functionality
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear_rounded,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            textController.clear();
            // Clear search when text is cleared for better UX
            _performSearch('', currentView, ref, context);
          },
        ),
        // Material 3 rounded input field styling
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      ),
      style: TextStyle(color: theme.colorScheme.onSurface),
      keyboardType: TextInputType.text,
      onChanged: (text) => _performSearch(text, currentView, ref, context),
    );
  }

  /// Performs search based on current view and handles error states
  /// Provides user feedback for failed searches with floating snackbars
  /// Performs search based on current view and handles error states
  /// Provides user feedback for failed searches with floating snackbars
  Future<void> _performSearch(String text, ChooseListView currentView, WidgetRef ref, BuildContext context) async {
    // Map current view to appropriate notifier type
    NotifierType? type;
    if (currentView == ChooseListView.label) {
      type = NotifierType.Label;
    }
    else if (currentView == ChooseListView.word) {
      type = NotifierType.Word;
    }
    else{
      type = NotifierType.NoDefinition;
    }
    
    // Perform search and handle results
    final service = ref.read(outputListNotifierProvider(type).notifier);
    bool success = await service.search(text);
    if (!context.mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.eventSearchFail),
          behavior: SnackBarBehavior.floating, // Modern floating snackbar
        ),
      );
    }
  }
}