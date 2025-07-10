import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/output/outputListNotifier.dart';

class InLabelSearchBar extends ConsumerStatefulWidget {
  final OutputListItem label;

  const InLabelSearchBar({super.key, required this.label});

  @override
  ConsumerState<InLabelSearchBar> createState() => _InLabelSearchBarState();
}

class _InLabelSearchBarState extends ConsumerState<InLabelSearchBar> {
  OutputListNotifier? service;
  final TextEditingController textController = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: loc.searchWordInLabel,
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          suffixIcon: textController.text.isNotEmpty 
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    textController.clear();
                    // Clear search when user clears the text
                    final service = ref.read(outputListNotifierProvider(NotifierType.Word, inlabel: true, labelId: widget.label.id).notifier);
                    service.searchInLabel('');
                  },
                )
              : null,
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
        keyboardType: TextInputType.text,
        onChanged: (text) async {
          setState(() {}); // Update UI for suffix icon visibility
          final service = ref.read(outputListNotifierProvider(NotifierType.Word, inlabel: true, labelId: widget.label.id).notifier);
          bool? success = await service.searchInLabel(text);
          if (!context.mounted) return;
          if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.eventSearchFail),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }
}