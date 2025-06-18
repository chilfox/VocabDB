import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/logic/output/outputListNotifier.dart';

// 假設你有這個 Provider，自動生成的
// final outputListNotifierProvider = ... (已由 @riverpod 自動產生)

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod OutputList Test',
      home: const OutputListPage(),
    );
  }
}

class OutputListPage extends ConsumerWidget {
  const OutputListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 監聽狀態 (List<String>)
    final outputList = ref.watch(outputListNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('OutputList 測試')),
      body: ListView.builder(
        itemCount: outputList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(outputList[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 呼叫 notifier 新增一筆字串
          ref.read(outputListNotifierProvider.notifier).addOutputString('新增項目 ${outputList.length + 1}');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
