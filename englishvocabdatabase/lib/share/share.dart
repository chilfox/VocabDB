import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ShareHandler {
  ShareHandler._privateConstructor();
  static final ShareHandler instance = ShareHandler._privateConstructor();

  // 初始化:initial, 監聽 stream
  Future<void> init() async {
    await _handleInitial();
    _listenStream();
  }

  // 啟動時呼叫：處理所有未處理過的文字
  Future<void> processPending(Function(String) onProcess) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('pending_shared') ?? [];
    for (var text in list) {
      onProcess(text);       // 交給傳入函數
    }
    await prefs.remove('pending_shared');
  }

  // 取 initialText
  Future<void> _handleInitial() async {
    final initial = await ReceiveSharingIntentPlus.getInitialText();
    if (initial != null && initial.isNotEmpty) {
      await _save(initial);
    }
  }

  // 持續監聽 share stream
  void _listenStream() {
    ReceiveSharingIntentPlus.getTextStream().listen((text) async {
      await _save(text);
    }, onError: (err) {
      debugPrint('分享接收錯誤: $err');
    });
  }

  // 存到 SharedPreferences
  Future<void> _save(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('pending_shared') ?? [];
    list.add(text);
    await prefs.setStringList('pending_shared', list);
    debugPrint('暫存分享文字: $list');
    debugPrint('\n end');
  }
}
