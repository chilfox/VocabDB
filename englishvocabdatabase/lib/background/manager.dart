import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class BackgroundManager {
  static const String _key = 'background_image';

  // 取得目前背景圖片 File
  static Future<File?> getBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    final fileName = prefs.getString(_key);
    if (fileName == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDir.path}/$fileName';
    final file = File(filePath);
    if (file.existsSync()) {
      return file;
    }
    return null;
  }

  // 選擇圖片並儲存到 app 目錄，含 Android 權限檢查
  static Future<File?> pickAndSaveBackgroundImage() async {
    if (Platform.isAndroid) {
      bool granted = await _checkAndRequestAndroidPermission();
      if (!granted) {
        openAppSettings(); // 跳到系統權限設定頁
        return null;
      }
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedFile.path);
    final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, fileName);

    return savedImage;
  }

  // Android 權限請求
  static Future<bool> _checkAndRequestAndroidPermission() async {
    // 針對 Android 13+ 要求 READ_MEDIA_IMAGES，舊版本用 READ_EXTERNAL_STORAGE
    if (await Permission.photos.isGranted) {
      return true;
    } else {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  // 清除背景圖片設定
  static Future<void> clearBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
