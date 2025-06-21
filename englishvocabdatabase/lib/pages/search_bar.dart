import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return SearchBar(
      leading: const Icon(Icons.search),
      hintText: 'Search word or label',
=======
    final TextEditingController textController = TextEditingController();
    final service = ref.read(outputServiceProvider);

    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: 'Search word or label',
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
        bool success = await service.search(text);
        if (!context.mounted) return;
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Search failed')),
          );
        }
      },
>>>>>>> Stashed changes
    );
  }
}