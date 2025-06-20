import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/logic/service/outputService.dart';

class MySearchBar extends ConsumerStatefulWidget {
  const MySearchBar({super.key});

  @override
  ConsumerState<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends ConsumerState<MySearchBar> {

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textController = TextEditingController();
    final service = ref.read(outputServiceProvider);

    return TextField(
      controller: _textController,
      decoration: InputDecoration(
        hintText: 'Search word or label',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton( // 添加一個清除按鈕
          icon: const Icon(Icons.clear),
          onPressed: () {
            _textController.clear(); // 清空 TextField，會觸發 onChanged
          },
        ),
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.text,
      onChanged: (text) async {
        bool success = await service.search(text);
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Search failed')),
          );
        }
      },
    );
  }
}