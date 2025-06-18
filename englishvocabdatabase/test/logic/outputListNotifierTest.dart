import 'package:flutter_test/flutter_test.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('addOutputString 新增元素', () {
    final container = ProviderContainer();
    final notifier = container.read(outputListNotifierProvider.notifier);

    notifier.addOutputString('A');
    expect(container.read(outputListNotifierProvider), ['A']);
  });

  test('refreshAll 替換整個資料', () {
    final container = ProviderContainer();
    final notifier = container.read(outputListNotifierProvider.notifier);

    notifier.refreshAll(['A', 'B']);
    expect(container.read(outputListNotifierProvider), ['A', 'B']);
  });

  test('deleteTarget 正常刪除', () {
    final container = ProviderContainer();
    final notifier = container.read(outputListNotifierProvider.notifier);

    notifier.refreshAll(['A', 'B', 'C']);
    bool result = notifier.deleteTarget('B');
    expect(result, true);
    expect(container.read(outputListNotifierProvider), ['A', 'C']);
  });

  test('deleteTarget 找不到回傳 false', () {
    final container = ProviderContainer();
    final notifier = container.read(outputListNotifierProvider.notifier);

    notifier.refreshAll(['A', 'B', 'C']);
    bool result = notifier.deleteTarget('D');
    expect(result, false);
    expect(container.read(outputListNotifierProvider), ['A', 'B', 'C']);
  });
}
