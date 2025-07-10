// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String eventError(Object message) {
    return 'Error $message';
  }

  @override
  String get eventDeleteFail => 'Delete Failed';

  @override
  String get eventSearchFail => 'Search failed';

  @override
  String get eventAddFail => 'Add Failed';

  @override
  String get eventCancel => 'Cancel';

  @override
  String get eventOk => 'OK';

  @override
  String get eventSave => 'Save';

  @override
  String get eventEdit => 'Edit';

  @override
  String get label => 'Label';

  @override
  String get word => 'Word';

  @override
  String get done => 'Done';

  @override
  String get searchbar => 'Search word or label';

  @override
  String get labelListEmpty => 'Label List is Empty';

  @override
  String get wordListEmpty => 'Word List is Empty';

  @override
  String get eventNoSelectWord => 'No words selected';

  @override
  String get enterWord => 'Please enter a word';

  @override
  String doneWordToLabel(Object successCount) {
    return 'Successfully added $successCount words to label';
  }

  @override
  String wordToLabelFail(Object successCount, Object totalCount) {
    return 'Added $successCount/$totalCount words. Some failed.';
  }

  @override
  String eventSaveFail(Object message) {
    return 'Failed to save changes: $message';
  }

  @override
  String get doneWordUpdate => 'Word updated successfully!';

  @override
  String get addWordBar => 'Add Word';

  @override
  String get addLabel => 'Add Label';

  @override
  String get addNewWord => 'Add new word';

  @override
  String get createLabel => 'Create New Label';

  @override
  String get typeLabelName => 'Type in new label name';

  @override
  String get typeWordName => 'Type in new word';

  @override
  String get doneUpdateBackground => 'Background image updated';

  @override
  String get eventBackgroundFail => 'No image selected or permission denied';

  @override
  String get buttonChooseBackground => 'Choose background image';

  @override
  String get doneClearBackground =>
      'Background image cleared, reverting to default';

  @override
  String get buttonClearBackground => 'Clear background image';

  @override
  String get buttonChangeLanguage => 'Change language';

  @override
  String get sectionBackground => 'Background Settings';

  @override
  String get sectionLanguage => 'Language Settings';

  @override
  String get sectionImport => 'Import Data';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get importFileButton => 'Import from CSV';

  @override
  String get importFileDescription =>
      'Select CSV file with \'name\', \'definition\', and \'chinese\' columns';

  @override
  String get fileSelected => 'File selected';

  @override
  String get fileEmpty => 'File is empty, please select another file';

  @override
  String get fileNoNameColumn =>
      'File missing \'name\' column, please select another file';

  @override
  String get fileImportSuccess => 'File imported successfully';

  @override
  String get searchWordNotInLabel => 'Search Word not in the Label';

  @override
  String get searchWordInLabel => 'Search Word in the Label';

  @override
  String get ocrProduct => 'OCR still in production';

  @override
  String get tempListEmpty => 'Temporary List is Empty';

  @override
  String get pageTitleWordBank => 'Word Bank';

  @override
  String get pageTitleTemporaryList => 'Temporary List';

  @override
  String get pageTitleImportExport => 'Import & Export';

  @override
  String get pageTitleSettings => 'Settings';

  @override
  String get browseIcon => 'Browse';

  @override
  String get temporaryIcon => 'Temporary';

  @override
  String get settingsIcon => 'Settings';

  @override
  String get wordHasnodef => 'This word has no definition yet';

  @override
  String get buttontoEdit =>
      'Tap the edit button to add definition, translation, and more details';

  @override
  String get addDefinition => 'Add Definition';

  @override
  String get enterDefinition => 'Enter word definition';

  @override
  String get chinese => 'chinese';

  @override
  String get addTranslate => 'Add translation';

  @override
  String get definition => 'Definition';

  @override
  String get partsOfSpeech => 'Part of Speech';

  @override
  String get example => 'Example';

  @override
  String get exampleSentence => 'Example Sentence';

  @override
  String get enterSentence => 'Enter an example sentence';

  @override
  String get nodefWarning =>
      'Please add some word information (definition, translation, etc.) before adding labels.';

  @override
  String get addLabelHint => 'Add word information first to enable labels.';

  @override
  String get noLabelHint => 'No labels yet. Add some to organize your words!';

  @override
  String get manageLabel => 'Manage Labels';

  @override
  String loadLabelFail(Object message) {
    return 'Failed to load labels $message';
  }

  @override
  String get apiLoadFail =>
      'Failed to load suggestions. Please check your network connection or try again later.';
}
