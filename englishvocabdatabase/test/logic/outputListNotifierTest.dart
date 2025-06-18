import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';

void main() {
  late ProviderContainer container;
  late OutputListNotifier notifier;
  late void Function() removeListener;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(outputListNotifierProvider.notifier);

    // 建立監聽，避免 AutoDispose provider 被釋放
    removeListener = container.listen<AsyncValue<List<OutputListItem>>>(
      outputListNotifierProvider,
      (previous, next) {},
    ).close;
  });

  tearDown(() {
    removeListener(); // 取消監聽
    container.dispose();
  });

  // 輔助函數：等待狀態變成 AsyncData
  Future<void> waitForAsyncData() async {
    while (container.read(outputListNotifierProvider) is! AsyncData) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  test('initial build() yields empty list', () async {
    await waitForAsyncData();
    final state = container.read(outputListNotifierProvider);
    expect(state, isA<AsyncData<List<OutputListItem>>>());
    final list = (state as AsyncData<List<OutputListItem>>).value;
    expect(list, isEmpty);
  });

  test('addOutputString adds one item', () async {
    await waitForAsyncData();

    final item = OutputListItem(name: 'Test Item', id: 42);
    notifier.addOutputString(item);

    await waitForAsyncData();

    final state = container.read(outputListNotifierProvider);
    final list = (state as AsyncData<List<OutputListItem>>).value;

    expect(list, contains(item));
    expect(list.length, 1);
  });

  test('addList appends multiple items', () async {
    await waitForAsyncData();

    final items = [
      OutputListItem(name: 'Item A', id: 1),
      OutputListItem(name: 'Item B', id: 2),
    ];

    notifier.addList(items);

    await waitForAsyncData();

    final state = container.read(outputListNotifierProvider);
    final list = (state as AsyncData<List<OutputListItem>>).value;

    expect(list.length, items.length);
    expect(list, containsAll(items));
  });

  test('refreshAll replaces entire list', () async {
    await waitForAsyncData();

    final newList = [
      OutputListItem(name: 'New X', id: 5),
      OutputListItem(name: 'New Y', id: 6),
    ];

    notifier.refreshAll(newList);

    await waitForAsyncData();

    final state = container.read(outputListNotifierProvider);
    final list = (state as AsyncData<List<OutputListItem>>).value;

    expect(list.length, newList.length);
    expect(list, equals(newList));
  });

  test('deleteTarget returns true when item exists and removes it', () async {
    await waitForAsyncData();

    final items = [
      OutputListItem(name: 'Keep', id: 10),
      OutputListItem(name: 'ToDelete', id: 99),
    ];
    notifier.refreshAll(items);

    await waitForAsyncData();

    // 確認刪除存在的項目成功
    final deleted = notifier.deleteTarget(99);
    expect(deleted, isTrue);

    await waitForAsyncData();

    final state = container.read(outputListNotifierProvider);
    final list = (state as AsyncData<List<OutputListItem>>).value;

    expect(list.any((e) => e.id == 99), isFalse);
    expect(list.length, 1);
  });

  test('deleteTarget returns false when item does not exist', () async {
    await waitForAsyncData();

    final items = [
      OutputListItem(name: 'OnlyItem', id: 1),
    ];
    notifier.refreshAll(items);

    await waitForAsyncData();

    final deleted = notifier.deleteTarget(999); // 不存在的id
    expect(deleted, isFalse);

    final state = container.read(outputListNotifierProvider);
    final list = (state as AsyncData<List<OutputListItem>>).value;

    // 確認列表不變
    expect(list.length, 1);
    expect(list[0].id, 1);
  });

  test('removeAll clears the list', () async {
    await waitForAsyncData();

    final items = [
      OutputListItem(name: 'SomeItem', id: 3),
    ];
    notifier.refreshAll(items);

    await waitForAsyncData();

    notifier.removeAll();

    await waitForAsyncData();

    final state = container.read(outputListNotifierProvider);
    final list = (state as AsyncData<List<OutputListItem>>).value;

    expect(list, isEmpty);
  });
}
