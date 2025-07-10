import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/output/outputListNotifier.dart';

/// AddBar widget for the TempPage (ClassifyPage)
/// 
/// The widget is stateless but uses a TextEditingController for form management.
/// It integrates with the OutputListNotifier to manage word addition operations.
class AddBar extends ConsumerWidget {
  const AddBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the OutputListNotifier service for managing no-definition words
    final service = ref.read(outputListNotifierProvider(NotifierType.NoDefinition).notifier);
    
    // Controller for managing text input state
    final TextEditingController addBarTextController = TextEditingController(); 
    
    // Get theme data for consistent Material 3 styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      // Apply Material 3 spacing guidelines (16dp horizontal padding)
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Main text input field - takes most of the available space
          Expanded(
            flex: 7,
            child: TextField(
              controller: addBarTextController,
              decoration: InputDecoration(
                // Material 3 outlined style with proper theming
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: colorScheme.error, width: 2.0),
                ),
                
                // Content styling
                hintText: AppLocalizations.of(context)!.addNewWord,
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: colorScheme.surface,
                
                // Icons with proper theming
                prefixIcon: Icon(
                  Icons.add_circle_outline,
                  color: colorScheme.primary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    addBarTextController.clear();
                  },
                  tooltip: 'Clear text',
                ),
                
                // Content padding for better touch targets
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
              ),
              
              // Input configuration
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              
              // Handle word submission
              onSubmitted: (text) async {
                // Validate input before processing
                final trimmedText = text.trim();
                if (trimmedText.isEmpty) {
                  // Show error for empty input
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.eventAddFail),
                      backgroundColor: colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                
                // Clear the text field immediately for better UX
                addBarTextController.clear();
                
                // Attempt to add the word to the temporary list
                int success = await service.add(trimmedText);
                
                // Check if widget is still mounted before showing feedback
                if (!context.mounted) return;
                
                // Provide user feedback based on operation result
                if (success == -1) {
                  // Show error feedback with Material 3 styling
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.error_outline, color: colorScheme.onError),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.eventAddFail,
                              style: TextStyle(color: colorScheme.onError),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16.0),
                    ),
                  );
                } else {
                  // Show success feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: colorScheme.onPrimary),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              'Word added successfully',
                              style: TextStyle(color: colorScheme.onPrimary),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16.0),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),
          
          // Spacing between text field and camera button
          const SizedBox(width: 12.0),
          
          // OCR Camera button - positioned separately for better layout
          Material(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                // Show OCR feature notification with improved styling
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.camera_alt, color: colorScheme.onPrimary),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.ocrProduct,
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: colorScheme.primary,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16.0),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: colorScheme.onSecondaryContainer,
                  size: 24.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
