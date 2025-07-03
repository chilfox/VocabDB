import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';


/// Manages the app's background image: pick, save, load, and clear.
class BackgroundManager {
  static const String _key = 'background_image';

  //background 圖變動版本
  static final ValueNotifier<int> backgroundVersion = ValueNotifier(0);

  /// Returns the currently saved background image file, or null if none.
  static Future<File?> getBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    final fileName = prefs.getString(_key);
    if (fileName == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final filePath = path.join(appDir.path, fileName);
    final file = File(filePath);
    return file.existsSync() ? file : null;
  }

  /// Lets user pick an image, saves it, and returns the saved file.
  /// If access denied, opens app settings and returns null.
  static Future<File?> pickAndSaveBackgroundImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return null; // user cancelled

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path)
          .copy(path.join(appDir.path, fileName));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, fileName);

      // 背景變更，通知 listener
      backgroundVersion.value++;

      return savedImage;
    } on Exception catch (e) {
      final info = await PackageInfo.fromPlatform();
      final intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:${info.packageName}',
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      await intent.launch();
      return null;
    }
  }

  /// Clears the saved background setting (does not delete the file).
  static Future<void> clearBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);

    // 清除時也通知 listener
    backgroundVersion.value++;
  }
}