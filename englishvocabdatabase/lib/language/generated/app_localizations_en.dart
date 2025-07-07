// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

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
}
