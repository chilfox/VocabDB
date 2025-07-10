import 'package:flutter/material.dart';
import 'package:englishvocabdatabase/background/manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/language/provider/locale_provider.dart';
import '../import_export/import.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Background Settings Section
            _buildSectionHeader(AppLocalizations.of(context)!.sectionBackground),
            _buildSectionCard(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final loc = AppLocalizations.of(context)!;
                      final file = await BackgroundManager.pickAndSaveBackgroundImage();
                      if (file != null) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(loc.doneUpdateBackground)),
                        );
                      } else {
                        messenger.showSnackBar(
                          SnackBar(content: Text(loc.eventBackgroundFail)),
                        );
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: Text(AppLocalizations.of(context)!.buttonChooseBackground),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: const Color.fromARGB(83, 212, 211, 211)
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final loc = AppLocalizations.of(context)!;
                      await BackgroundManager.clearBackgroundImage();
                      messenger.showSnackBar(
                        SnackBar(content: Text(loc.doneClearBackground)),
                      );
                    },
                    icon: const Icon(Icons.clear),
                    label: Text(AppLocalizations.of(context)!.buttonClearBackground),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Language Settings Section
            _buildSectionHeader(AppLocalizations.of(context)!.sectionLanguage),
            _buildSectionCard(
              child: Consumer(
                builder: (context, ref, child) {
                  final currentLocale = ref.watch(localeProvider);
                  final loc = AppLocalizations.of(context)!;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SegmentedButton<String>(
                        segments: [
                          ButtonSegment<String>(
                            value: 'en',
                            label: Text(loc.languageEnglish),
                            icon: const Icon(Icons.language),
                          ),
                          ButtonSegment<String>(
                            value: 'zh',
                            label: Text(loc.languageChinese),
                            icon: const Icon(Icons.translate),
                          ),
                        ],
                        selected: {currentLocale.languageCode},
                        onSelectionChanged: (Set<String> newSelection) {
                          setLocale(ref, newSelection.first);
                        },
                        style: SegmentedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Import Data Section
            _buildSectionHeader(AppLocalizations.of(context)!.sectionImport),
            _buildSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.importFileDescription,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final loc = AppLocalizations.of(context)!;
                      String? content = await pickAndUploadFile();
                      if (content != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(loc.fileSelected)),
                        );
                        var csvlist = await parseCsvString(content);
                        int result = await convertCsvToWords(csvlist);
                        if (result == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(loc.fileEmpty)),
                          );
                        } else if (result == -1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(loc.fileNoNameColumn)),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(loc.fileImportSuccess)),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    label: Text(AppLocalizations.of(context)!.importFileButton),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}