import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/service/outputService.dart'; // 假設 service 定義在這

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

    return Scaffold(
      appBar: AppBar(title: const Text('Output List (Label)')),
      body: asyncList.when(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 呼叫 service 的 search 方法，並傳入字串 'test'
          bool success = await service.search('test');
          if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Search failed')),
            );
          }
        },
        child: const Icon(Icons.search),
      ),
    );
  }
}
