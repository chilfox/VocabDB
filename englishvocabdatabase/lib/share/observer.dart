import 'package:flutter/widgets.dart';
import 'share.dart';
import 'processShare.dart';

class ShareObserver with WidgetsBindingObserver {
  void init() {
    WidgetsBinding.instance.addObserver(this);
    _handleNativeSharedData();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleNativeSharedData();
    }
  }

  Future<void> _handleNativeSharedData() async {
    debugPrint('oberver handle');
    final dataList = await ShareHandler.instance.getAllStoredData();

    if (dataList.isEmpty) return;

    for (final data in dataList) {
      final sharedText = data['shared_text'];
      final definition = data['definition'];
      final chinese = data['chinese'];
      if (sharedText != null && sharedText.isNotEmpty) {
        debugPrint('App 回到前景收到: $sharedText');
        ShareProcessor.processText(sharedText, definition, chinese);
      }
    }

    // 處理完清掉 native 的暫存，避免重複處理
    await ShareHandler.instance.clearAllStoredData();
  }
}
