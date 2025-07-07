import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final localeProvider = StateProvider<Locale>((ref) {
  // 默認英文
  return const Locale('en');
});

// 切換
void toggleLocale(WidgetRef ref) {
  final current = ref.read(localeProvider);
  final next = current.languageCode == 'en'
      ? const Locale('zh')
      : const Locale('en');
  ref.read(localeProvider.notifier).state = next;
}
