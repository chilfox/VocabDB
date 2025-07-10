import 'package:flutter/material.dart';
import 'package:englishvocabdatabase/background/manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/language/provider/locale_provider.dart';
import '../import_export/import.dart';

/// SettingsPage widget for app configuration and preferences
/// 
/// This page provides access to various app settings organized into logical sections:
/// - Background customization (choose/clear background images)
/// - Language selection (English/Chinese localization)
/// - Data import functionality (CSV file import)
/// 
/// All settings changes are persisted automatically and provide immediate feedback.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// Creates consistent section headers throughout the settings page
  /// with proper theming and visual hierarchy.
  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Row(
        children: [
          // Visual indicator for sections
          Container(
            width: 4.0,
            height: 20.0,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(width: 12.0),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a section card with Material 3 surface styling
  /// 
  /// Creates consistent card containers for grouping related settings
  /// with proper elevation, spacing, and theming.
  Widget _buildSectionCard(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }

  /// Shows a Material 3 styled SnackBar with enhanced feedback
  /// 
  /// Provides consistent user feedback with icons and proper theming
  /// for success, error, and informational messages.
  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    bool isSuccess = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Color backgroundColor;
    Color textColor;
    IconData iconData;
    
    if (isError) {
      backgroundColor = colorScheme.errorContainer;
      textColor = colorScheme.onErrorContainer;
      iconData = Icons.error_outline;
    } else if (isSuccess) {
      backgroundColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
      iconData = Icons.check_circle_outline;
    } else {
      backgroundColor = colorScheme.inverseSurface;
      textColor = colorScheme.onInverseSurface;
      iconData = Icons.info_outline;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(iconData, color: textColor, size: 20.0),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        duration: Duration(seconds: isError ? 4 : 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;
    
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Background Settings Section
          _buildSectionHeader(context, loc.sectionBackground),
          _buildSectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section description
                Text(
                  loc.descriptionBackground,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20.0),
                
                // Choose background button with Material 3 styling
                FilledButton.icon(
                  onPressed: () async {
                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: colorScheme.primary),
                              const SizedBox(height: 16.0),
                              Text(
                                'Selecting image...',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    
                    try {
                      final file = await BackgroundManager.pickAndSaveBackgroundImage();
                      
                      // Close loading dialog
                      if (context.mounted) Navigator.of(context).pop();
                      
                      if (file != null) {
                        _showSnackBar(
                          context,
                          loc.doneUpdateBackground,
                          isSuccess: true,
                        );
                      } else {
                        _showSnackBar(
                          context,
                          loc.eventBackgroundFail,
                          isError: true,
                        );
                      }
                    } catch (e) {
                      // Close loading dialog and show error
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        _showSnackBar(
                          context,
                          'Failed to update background: ${e.toString()}',
                          isError: true,
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.image_outlined),
                  label: Text(loc.buttonChooseBackground),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12.0),
                
                // Clear background button with Material 3 styling
                OutlinedButton.icon(
                  onPressed: () async {
                    // Show confirmation dialog
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: colorScheme.surface,
                        surfaceTintColor: colorScheme.surfaceTint,
                        icon: Icon(
                          Icons.delete_outline,
                          color: colorScheme.error,
                          size: 24.0,
                        ),
                        title: Text(
                          'Clear Background',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        content: Text(
                          'Are you sure you want to remove the current background image?',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: colorScheme.primary),
                            ),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.error,
                              foregroundColor: colorScheme.onError,
                            ),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    ) ?? false;
                    
                    if (confirmed) {
                      await BackgroundManager.clearBackgroundImage();
                      _showSnackBar(
                        context,
                        loc.doneClearBackground,
                        isSuccess: true,
                      );
                    }
                  },
                  icon: const Icon(Icons.clear_outlined),
                  label: Text(loc.buttonClearBackground),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    foregroundColor: colorScheme.error,
                    side: BorderSide(color: colorScheme.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
      
          // Language Settings Section
          _buildSectionHeader(context, loc.sectionLanguage),
          _buildSectionCard(
            context,
            child: Consumer(
              builder: (context, ref, child) {
                final currentLocale = ref.watch(localeProvider);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section description
                    Text(
                      loc.descriptionLanguage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    
                    // Language selection with enhanced Material 3 styling
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment<String>(
                          value: 'en',
                          label: Text(
                            loc.languageEnglish,
                            style: theme.textTheme.labelLarge,
                          ),
                          icon: const Icon(Icons.language_outlined),
                        ),
                        ButtonSegment<String>(
                          value: 'zh',
                          label: Text(
                            loc.languageChinese,
                            style: theme.textTheme.labelLarge,
                          ),
                          icon: const Icon(Icons.translate_outlined),
                        ),
                      ],
                      selected: {currentLocale.languageCode},
                      onSelectionChanged: (Set<String> newSelection) {
                        setLocale(ref, newSelection.first);
                        _showSnackBar(
                          context,
                          'Language updated successfully',
                          isSuccess: true,
                        );
                      },
                      style: SegmentedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        backgroundColor: colorScheme.surface,
                        foregroundColor: colorScheme.onSurface,
                        selectedBackgroundColor: colorScheme.primaryContainer,
                        selectedForegroundColor: colorScheme.onPrimaryContainer,
                        side: BorderSide(color: colorScheme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      
          // Import Data Section
          _buildSectionHeader(context, loc.sectionImport),
          _buildSectionCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced section description
                Text(
                  loc.descriptionImportExport,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8.0),
                
                // Detailed description with formatting
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    loc.importFileDescription,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20.0),
                
                // Import button with enhanced styling
                FilledButton.icon(
                  onPressed: () async {
                    try {
                      // Show loading state
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(color: colorScheme.primary),
                                const SizedBox(height: 16.0),
                                Text(
                                  'Processing import...',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      
                      String? content = await pickAndUploadFile();
                      
                      if (content != null) {
                        _showSnackBar(context, loc.fileSelected);
                        
                        var csvlist = await parseCsvString(content);
                        int result = await convertCsvToWords(csvlist);
                        
                        // Close loading dialog
                        if (context.mounted) Navigator.of(context).pop();
                        
                        // Show result feedback
                        if (result == 0) {
                          _showSnackBar(
                            context,
                            loc.fileEmpty,
                            isError: true,
                          );
                        } else if (result == -1) {
                          _showSnackBar(
                            context,
                            loc.fileNoNameColumn,
                            isError: true,
                          );
                        } else {
                          _showSnackBar(
                            context,
                            '${loc.fileImportSuccess} ($result words imported)',
                            isSuccess: true,
                          );
                        }
                      } else {
                        // Close loading dialog
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    } catch (e) {
                      // Close loading dialog and show error
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        _showSnackBar(
                          context,
                          'Import failed: ${e.toString()}',
                          isError: true,
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.upload_file_outlined),
                  label: Text(loc.importFileButton),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: colorScheme.secondaryContainer,
                    foregroundColor: colorScheme.onSecondaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                
                SizedBox(height: 12.0,),
      
                // Export button with enhanced styling
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.file_download_outlined),
                  label: Text(loc.exportFileButton),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: colorScheme.secondaryContainer,
                    foregroundColor: colorScheme.onSecondaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ],
            ),
          ), 
        ],
      ),
    );
  }
}