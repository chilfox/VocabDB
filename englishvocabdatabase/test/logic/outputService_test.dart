import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/logic/service/outputService.dart'; // 你的 service

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: OutputListPage(),
    );
  }
}

class OutputListPage extends ConsumerWidget {
  const OutputListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Label));
    final service = ref.read(outputServiceProvider);
    final type = NotifierType.Label;

    return Scaffold(
      appBar: AppBar(title: const Text('Output List (Label)')),
      body: Column(
        children: [
          Expanded(
            child: asyncList.when(
              data: (list) {
                if (list.isEmpty) {
                  return const Center(child: Text('List is empty'));
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text('ID: ${item.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
          // 三個按鈕獨立成 Widget
          SearchButton(service: service),
          AddButton(service: service),
          DeleteButton(service: service),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// 按鈕1 - 呼叫 service.search('test')
class SearchButton extends StatelessWidget {
  final OutputService service;
  const SearchButton({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        bool success = await service.search('test');
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Search failed')),
          );
        }
      },
      child: const Text('Search'),
    );
  }
}

// 按鈕2 - 呼叫 service.add('New Item')
class AddButton extends StatelessWidget {
  final OutputService service;
  const AddButton({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        bool success = await service.add('New Item');
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add failed')),
          );
        }
      },
      child: const Text('Add'),
    );
  }
}

// 按鈕3 - 呼叫 service.delete('New Item', 0)
class DeleteButton extends StatelessWidget {
  final OutputService service;
  const DeleteButton({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        bool success = await service.delete('New Item', 0);
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Delete failed')),
          );
        }
      },
      child: const Text('Delete'),
    );
  }
}
