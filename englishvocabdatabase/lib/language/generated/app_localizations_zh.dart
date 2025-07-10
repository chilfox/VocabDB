// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String eventError(Object message) {
    return '錯誤 $message';
  }

  @override
  String get eventDeleteFail => '刪除失敗';

  @override
  String get eventSearchFail => '搜尋失敗';

  @override
  String get eventAddFail => '新增失敗';

  @override
  String get eventCancel => '取消';

  @override
  String get eventOk => '確定';

  @override
  String get eventSave => '儲存';

  @override
  String get eventEdit => '編輯';

  @override
  String get label => '標籤';

  @override
  String get word => '單字';

  @override
  String get done => '完成';

  @override
  String get searchbar => '搜尋標籤或單字';

  @override
  String get labelListEmpty => '標籤列為空';

  @override
  String get wordListEmpty => '單字列為空';

  @override
  String get eventNoSelectWord => '尚未選擇任何單字';

  @override
  String get enterWord => '請輸入單字';

  @override
  String doneWordToLabel(Object successCount) {
    return '成功新增所有單字(共 $successCount 個) 到標籤中';
  }

  @override
  String wordToLabelFail(Object successCount, Object totalCount) {
    return '成功新增 $successCount/$totalCount 個單字，部分單字新增失敗';
  }

  @override
  String eventSaveFail(Object message) {
    return '儲存失敗: $message';
  }

  @override
  String get doneWordUpdate => '單字更新成功!';

  @override
  String get addWordBar => '新增單字';

  @override
  String get addLabel => '新增標籤';

  @override
  String get addNewWord => '新增單字';

  @override
  String get createLabel => '建立新標籤';

  @override
  String get typeLabelName => '輸入新標籤名稱';

  @override
  String get typeWordName => '輸入單字名稱';

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

  @override
  String get sectionBackground => '背景設定';

  @override
  String get sectionLanguage => '語言設定';

  @override
  String get sectionImport => '匯入資料';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get importFileButton => '從 CSV 匯入';

  @override
  String get importFileDescription =>
      '選擇包含 \'name\'、\'definition\' 和 \'chinese\' 欄位的 CSV 檔案';

  @override
  String get fileSelected => '已選擇檔案';

  @override
  String get fileEmpty => '檔案內容是空的，請重新選擇';

  @override
  String get fileNoNameColumn => '檔案內容沒有 name 的欄位，請重新選擇';

  @override
  String get fileImportSuccess => '檔案內容已經成功上傳';

  @override
  String get searchWordNotInLabel => '搜尋不在此標籤中的單字';

  @override
  String get searchWordInLabel => '搜尋此標籤中的單字';

  @override
  String get ocrProduct => 'OCR功能開發中';

  @override
  String get tempListEmpty => '暫存列為空';

  @override
  String get pageTitleWordBank => '單字庫';

  @override
  String get pageTitleTemporaryList => '暫存清單';

  @override
  String get pageTitleImportExport => 'Import & Export';

  @override
  String get pageTitleSettings => '設定';

  @override
  String get browseIcon => '瀏覽';

  @override
  String get temporaryIcon => '暫存';

  @override
  String get settingsIcon => '設定';

  @override
  String get wordHasnodef => '此單字未定義';

  @override
  String get buttontoEdit => '點擊編輯按鈕，新增英文定義、中文翻譯以及更多細節';

  @override
  String get addDefinition => '新增英文定義';

  @override
  String get enterDefinition => '輸入英文定義';

  @override
  String get chinese => '中文';

  @override
  String get addTranslate => '新增翻譯';

  @override
  String get definition => '英文定義';

  @override
  String get partsOfSpeech => '詞性';

  @override
  String get example => '範例';

  @override
  String get exampleSentence => '例句';

  @override
  String get enterSentence => '輸入例句';

  @override
  String get nodefWarning => '請在加入標籤前，新增定義、翻譯等';

  @override
  String get addLabelHint => '加入標籤前，請先新增單字資訊';

  @override
  String get noLabelHint => '尚未加入標籤．增加標籤來整理單字!';

  @override
  String get manageLabel => '管理標籤';

  @override
  String loadLabelFail(Object message) {
    return '標籤載入失敗 $message';
  }

  @override
  String get apiLoadFail => '載入建議失敗，請檢查網路或稍後再試';
}
