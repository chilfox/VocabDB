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
  AsyncValue<List<OutputListItem>>? service;

  @override
  void initState(){
    super.initState();
    service = ref.read(outputListNotifierProvider(NotifierType.Word));
    /*
    service.searchInLabel('', widget.label.id);
    */
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: 'Search Word in the Label',
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
      /*
      onChanged: (text) async {       
        bool success = await service.searchInLabel(text, widget.label.id);
        if (!context.mounted) return;
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Search failed')),
          );
        }
      }
      */
    );
  }
}