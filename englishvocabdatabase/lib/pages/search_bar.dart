import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'word_bank_page.dart';
import '../logic/output/outputListNotifier.dart';

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
    
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: 'Search word or label',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton( // 添加一個清除按鈕
          icon: const Icon(Icons.clear),
          onPressed: () {
            textController.clear(); // 清空 TextField，會觸發 onChanged
          },
        ),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      onChanged: (text) async {
        // 對應 currentView 去選 notifier type
        final NotifierType type = (currentView == ChooseListView.label)
            ? NotifierType.Label
            : NotifierType.Word;
        final service = ref.read(outputListNotifierProvider(type).notifier);
        bool success = await service.search(text);
        if (!context.mounted) return;
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Search failed')),
          );
        }
      },
    );
  }
}