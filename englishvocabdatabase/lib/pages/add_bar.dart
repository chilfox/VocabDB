import 'package:englishvocabdatabase/logic/service/outputService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBar extends ConsumerWidget {
  const AddBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(outputServiceProvider);
    final TextEditingController addBarTextController = TextEditingController(); 

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: TextField(
            controller: addBarTextController, 
            decoration: InputDecoration(
              hintText: 'Add new word',
              prefixIcon: const Icon(Icons.add),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  addBarTextController.clear();
                },
              ),
            ),
            keyboardType: TextInputType.text,
            onSubmitted: (text) async {
              addBarTextController.clear();
              bool success = await service.add(text);
              if(!context.mounted) return;
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add Failed')),
                );
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: IconButton(
              icon: Icon(Icons.camera_alt_rounded),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OCR still in production')),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
