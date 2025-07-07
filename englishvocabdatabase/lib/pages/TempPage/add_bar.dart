import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/output/outputListNotifier.dart';

class AddBar extends ConsumerWidget {
  const AddBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(outputListNotifierProvider(NotifierType.NoDefinition).notifier);
    
    final TextEditingController addBarTextController = TextEditingController(); 

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: TextField(
              controller: addBarTextController, 
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.addNewWord,
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
                int success = await service.add(text);
                if(!context.mounted) return;
                if (success == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.eventAddFail)),
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.camera_alt_rounded),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context)!.ocrProduct)),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
