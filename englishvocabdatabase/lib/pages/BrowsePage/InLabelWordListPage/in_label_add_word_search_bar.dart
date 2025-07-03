import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/output/outputListNotifier.dart';

class InLabelAddWordSearchBar extends ConsumerStatefulWidget {
  final OutputListItem label;

  const InLabelAddWordSearchBar({super.key, required this.label});

  @override
  ConsumerState<InLabelAddWordSearchBar> createState() => _InLabelAddWordSearchBarState();
}

class _InLabelAddWordSearchBarState extends ConsumerState<InLabelAddWordSearchBar> {
  OutputListNotifier? service;
  final TextEditingController textController = TextEditingController();

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: 'Search Word not in the Label',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            textController.clear();
          },
        ),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      onChanged: (text) async {       
        final service = ref.read(outputListNotifierProvider(NotifierType.Word, inlabel: false, labelId: widget.label.id).notifier);
        bool? success = await service.searchNotInLabel(text);
        if (!context.mounted) return;
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Search failed')),
          );
        }
      }
    );
  }
}