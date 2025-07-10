import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @eventError.
  ///
  /// In en, this message translates to:
  /// **'Error {message}'**
  String eventError(Object message);

  /// No description provided for @eventDeleteFail.
  ///
  /// In en, this message translates to:
  /// **'Delete Failed'**
  String get eventDeleteFail;

  /// No description provided for @eventSearchFail.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get eventSearchFail;

  /// No description provided for @eventAddFail.
  ///
  /// In en, this message translates to:
  /// **'Add Failed'**
  String get eventAddFail;

  /// No description provided for @eventCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get eventCancel;

  /// No description provided for @eventOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get eventOk;

  /// No description provided for @eventSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get eventSave;

  /// No description provided for @eventEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get eventEdit;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @word.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get word;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @searchbar.
  ///
  /// In en, this message translates to:
  /// **'Search word or label'**
  String get searchbar;

  /// No description provided for @noDefSearchbar.
  ///
  /// In en, this message translates to:
  /// **'Search word without properties'**
  String get noDefSearchbar;

  /// No description provided for @labelListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Label List is Empty'**
  String get labelListEmpty;

  /// No description provided for @wordListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Word List is Empty'**
  String get wordListEmpty;

  /// No description provided for @eventNoSelectWord.
  ///
  /// In en, this message translates to:
  /// **'No words selected'**
  String get eventNoSelectWord;

  /// No description provided for @enterWord.
  ///
  /// In en, this message translates to:
  /// **'Please enter a word'**
  String get enterWord;

  /// No description provided for @doneWordToLabel.
  ///
  /// In en, this message translates to:
  /// **'Successfully added {successCount} words to label'**
  String doneWordToLabel(Object successCount);

  /// No description provided for @wordToLabelFail.
  ///
  /// In en, this message translates to:
  /// **'Added {successCount}/{totalCount} words. Some failed.'**
  String wordToLabelFail(Object successCount, Object totalCount);

  /// No description provided for @eventSaveFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to save changes: {message}'**
  String eventSaveFail(Object message);

  /// No description provided for @doneWordUpdate.
  ///
  /// In en, this message translates to:
  /// **'Word updated successfully!'**
  String get doneWordUpdate;

  /// No description provided for @addWordBar.
  ///
  /// In en, this message translates to:
  /// **'Add Word'**
  String get addWordBar;

  /// No description provided for @addLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Label'**
  String get addLabel;

  /// No description provided for @addNewWord.
  ///
  /// In en, this message translates to:
  /// **'Add new word'**
  String get addNewWord;

  /// No description provided for @createLabel.
  ///
  /// In en, this message translates to:
  /// **'Create New Label'**
  String get createLabel;

  /// No description provided for @typeLabelName.
  ///
  /// In en, this message translates to:
  /// **'Type in new label name'**
  String get typeLabelName;

  /// No description provided for @typeWordName.
  ///
  /// In en, this message translates to:
  /// **'Type in new word'**
  String get typeWordName;

  /// No description provided for @doneUpdateBackground.
  ///
  /// In en, this message translates to:
  /// **'Background image updated'**
  String get doneUpdateBackground;

  /// No description provided for @eventBackgroundFail.
  ///
  /// In en, this message translates to:
  /// **'No image selected or permission denied'**
  String get eventBackgroundFail;

  /// No description provided for @buttonChooseBackground.
  ///
  /// In en, this message translates to:
  /// **'Choose background image'**
  String get buttonChooseBackground;

  /// No description provided for @doneClearBackground.
  ///
  /// In en, this message translates to:
  /// **'Background image cleared, reverting to default'**
  String get doneClearBackground;

  /// No description provided for @buttonClearBackground.
  ///
  /// In en, this message translates to:
  /// **'Clear background image'**
  String get buttonClearBackground;

  /// No description provided for @buttonChangeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get buttonChangeLanguage;

  /// No description provided for @sectionBackground.
  ///
  /// In en, this message translates to:
  /// **'Background Settings'**
  String get sectionBackground;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get sectionLanguage;

  /// No description provided for @sectionImport.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get sectionImport;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @importFileButton.
  ///
  /// In en, this message translates to:
  /// **'Import from CSV'**
  String get importFileButton;

  /// No description provided for @importFileDescription.
  ///
  /// In en, this message translates to:
  /// **'Select CSV file with \'name\' column (required). \'definition\' and \'chinese\' columns are optional'**
  String get importFileDescription;

  /// No description provided for @fileSelected.
  ///
  /// In en, this message translates to:
  /// **'File selected'**
  String get fileSelected;

  /// No description provided for @fileEmpty.
  ///
  /// In en, this message translates to:
  /// **'File is empty, please select another file'**
  String get fileEmpty;

  /// No description provided for @fileNoNameColumn.
  ///
  /// In en, this message translates to:
  /// **'File missing \'name\' column, please select another file'**
  String get fileNoNameColumn;

  /// No description provided for @fileImportSuccess.
  ///
  /// In en, this message translates to:
  /// **'File imported successfully'**
  String get fileImportSuccess;

  /// No description provided for @searchWordNotInLabel.
  ///
  /// In en, this message translates to:
  /// **'Search Word not in the Label'**
  String get searchWordNotInLabel;

  /// No description provided for @searchWordInLabel.
  ///
  /// In en, this message translates to:
  /// **'Search Word in the Label'**
  String get searchWordInLabel;

  /// No description provided for @ocrProduct.
  ///
  /// In en, this message translates to:
  /// **'OCR still in production'**
  String get ocrProduct;

  /// No description provided for @tempListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Temporary List is Empty'**
  String get tempListEmpty;

  /// No description provided for @pageTitleWordBank.
  ///
  /// In en, this message translates to:
  /// **'Word Bank'**
  String get pageTitleWordBank;

  /// No description provided for @pageTitleTemporaryList.
  ///
  /// In en, this message translates to:
  /// **'Temporary List'**
  String get pageTitleTemporaryList;

  /// No description provided for @pageTitleImportExport.
  ///
  /// In en, this message translates to:
  /// **'Import & Export'**
  String get pageTitleImportExport;

  /// No description provided for @pageTitleSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get pageTitleSettings;

  /// No description provided for @browseIcon.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browseIcon;

  /// No description provided for @temporaryIcon.
  ///
  /// In en, this message translates to:
  /// **'Temporary'**
  String get temporaryIcon;

  /// No description provided for @settingsIcon.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsIcon;

  /// No description provided for @wordHasnodef.
  ///
  /// In en, this message translates to:
  /// **'This word has no definition yet'**
  String get wordHasnodef;

  /// No description provided for @buttontoEdit.
  ///
  /// In en, this message translates to:
  /// **'Tap the edit button to add definition, translation, and more details'**
  String get buttontoEdit;

  /// No description provided for @addDefinition.
  ///
  /// In en, this message translates to:
  /// **'Add Definition'**
  String get addDefinition;

  /// No description provided for @enterDefinition.
  ///
  /// In en, this message translates to:
  /// **'Enter word definition'**
  String get enterDefinition;

  /// No description provided for @chinese.
  ///
  /// In en, this message translates to:
  /// **'chinese'**
  String get chinese;

  /// No description provided for @addTranslate.
  ///
  /// In en, this message translates to:
  /// **'Add translation'**
  String get addTranslate;

  /// No description provided for @definition.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get definition;

  /// No description provided for @partsOfSpeech.
  ///
  /// In en, this message translates to:
  /// **'Part of Speech'**
  String get partsOfSpeech;

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get example;

  /// No description provided for @exampleSentence.
  ///
  /// In en, this message translates to:
  /// **'Example Sentence'**
  String get exampleSentence;

  /// No description provided for @enterSentence.
  ///
  /// In en, this message translates to:
  /// **'Enter an example sentence'**
  String get enterSentence;

  /// No description provided for @nodefWarning.
  ///
  /// In en, this message translates to:
  /// **'Please add some word information (definition, translation, etc.) before adding labels.'**
  String get nodefWarning;

  /// No description provided for @addLabelHint.
  ///
  /// In en, this message translates to:
  /// **'Add word information first to enable labels.'**
  String get addLabelHint;

  /// No description provided for @noLabelHint.
  ///
  /// In en, this message translates to:
  /// **'No labels yet. Add some to organize your words!'**
  String get noLabelHint;

  /// No description provided for @manageLabel.
  ///
  /// In en, this message translates to:
  /// **'Manage Labels'**
  String get manageLabel;

  /// No description provided for @loadLabelFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to load labels {message}'**
  String loadLabelFail(Object message);

  /// No description provided for @apiLoadFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to load suggestions. Please check your network connection or try again later.'**
  String get apiLoadFail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
