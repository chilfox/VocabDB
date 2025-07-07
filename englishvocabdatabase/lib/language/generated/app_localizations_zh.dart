// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get doneUpdateBackground => '背景圖片已更新';

  @override
  String get eventBackgroundFail => '沒有選擇圖片或權限不足';

  @override
  String get buttonChooseBackground => '選擇背景圖片';

  @override
  String get doneClearBackground => '背景圖片已清除，將恢復預設背景';

  @override
  String get buttonClearBackground => '清除背景圖片';

  @override
  String get buttonChangeLanguage => '切換語言';
}
