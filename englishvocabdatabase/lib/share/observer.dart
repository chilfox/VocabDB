import 'package:flutter/widgets.dart';
import 'share.dart';
import 'processShare.dart';

class ShareObserver with WidgetsBindingObserver {
  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ShareHandler.instance.processPending(ShareProcessor.processText);
    }
  }
}
