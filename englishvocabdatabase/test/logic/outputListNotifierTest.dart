import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';

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
    // 監聽 NotifierType.Label 的 provider 狀態
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Label));

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
        onPressed: () {
          // 呼叫 notifier 新增一筆
          final notifier = ref.read(outputListNotifierProvider(NotifierType.Label).notifier);
          final newItem = OutputListItem(
            id: DateTime.now().millisecondsSinceEpoch,
            name: 'New Item ${DateTime.now().second}',
          );
          notifier.addOutputString(newItem);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
