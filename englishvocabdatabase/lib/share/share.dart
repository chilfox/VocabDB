import 'package:flutter/services.dart';
import 'dart:convert';

class ShareHandler {
  ShareHandler._privateConstructor();
  static final ShareHandler instance = ShareHandler._privateConstructor();

  static const _channel = MethodChannel('com.example.englishvocabdatabase/floating_prefs');

  /// 從 native 取得所有存的資料
  Future<List<Map<String, String?>>> getAllStoredData() async {
    final String? jsonString = await _channel.invokeMethod('getAllInputs');
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((item) => Map<String, String?>.from(item)).toList();
  }


  /// 清除 native 存的資料
  Future<void> clearAllStoredData() async {
    await _channel.invokeMethod('clearInputs');
  }
}
