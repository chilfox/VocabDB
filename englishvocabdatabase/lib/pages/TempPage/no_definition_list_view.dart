import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/pages/word_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';

/// NoDefinitionListView widget for displaying words without definitions
/// 
/// This widget shows a list of words that have been added to the temporary list
/// but don't have definitions yet. It follows Material 3 design guidelines with:
/// - Modern list item styling with proper spacing and typography
/// - Swipe-to-delete functionality using Slidable
/// - Loading and error states with appropriate feedback
/// - Visual distinction from defined vocabulary words
/// - Accessibility support with proper semantic labels
/// 
/// Each list item supports:
/// - Tap to navigate to word detail/edit view
/// - Swipe left to reveal delete action
/// - Material 3 theming for consistent appearance
class NoDefinitionListView extends ConsumerStatefulWidget {
  const NoDefinitionListView({super.key});

  @override
  ConsumerState<NoDefinitionListView> createState() => _NoDefinitionListViewState();
}

class _NoDefinitionListViewState extends ConsumerState<NoDefinitionListView> {
  @override
  Widget build(BuildContext context) {
    // Watch the async list of no-definition words
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.NoDefinition));
    final service = ref.read(outputListNotifierProvider(NotifierType.NoDefinition).notifier);
    
    // Get theme data for consistent Material 3 styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return asyncList.when(
      // Data loaded successfully - display the word list
      data: (list) {
        if (list.isEmpty) {
          // Empty state with Material 3 styling
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.library_books_outlined,
                  size: 64.0,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16.0),
                Text(
                  AppLocalizations.of(context)!.tempListEmpty,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Add words using the input field above',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        // Display the list of words with Material 3 styling
        return ListView.builder(
          // Add padding for better visual hierarchy
          padding: const EdgeInsets.only(top: 8.0),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return _buildNoDefinitionWidget(context, item, service, colorScheme, theme);
          },
        );
      },
      
      // Loading state with Material 3 progress indicator
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Loading words...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      
      // Error state with Material 3 error styling
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.0,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.eventError(err),
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an individual no-definition word widget with Material 3 styling
  /// 
  /// This method creates a list item that:
  /// - Uses Slidable for swipe-to-delete functionality
  /// - Applies Material 3 theming and spacing
  /// - Provides clear visual hierarchy
  /// - Supports accessibility features
  /// - Handles navigation to word detail view
  Widget _buildNoDefinitionWidget(
    BuildContext context,
    OutputListItem item,
    OutputListNotifier service,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Container(
      // Add subtle margin between items
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      
      // Material 3 surface container styling
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      
      child: Slidable(
        // Unique key for each item to maintain state during list updates
        key: ValueKey(item.id),
        
        // Swipe-to-delete action with Material 3 styling
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) async {
                // Show confirmation dialog before deletion
                final confirmed = await _showDeleteConfirmation(context, item.name);
                if (!confirmed) return;
                
                // Perform deletion operation
                bool success = await service.delete(item.id);
                
                // Check if widget is still mounted before showing feedback
                if (!context.mounted) return;
                
                if (!success) {
                  // Show error feedback with Material 3 styling
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.error_outline, color: colorScheme.onError),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.eventDeleteFail,
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
                          Text(
                            'Word deleted successfully',
                            style: TextStyle(color: colorScheme.onPrimary),
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
              backgroundColor: colorScheme.errorContainer,
              foregroundColor: colorScheme.onErrorContainer,
              icon: Icons.delete_outline,
              label: 'Delete',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
          ],
        ),
        
        // Main list item content
        child: ListTile(
          // Visual indicator that this word needs definition
          leading: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Icon(
              Icons.help_outline,
              color: colorScheme.onTertiaryContainer,
              size: 20.0,
            ),
          ),
          
          // Word title with appropriate typography
          title: Text(
            item.name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Subtitle indicating status
          subtitle: Text(
            'Tap to add definition',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
          
          // Trailing arrow for navigation indication
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: colorScheme.onSurfaceVariant,
            size: 16.0,
          ),
          
          // Enhanced content padding for better touch targets
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
          
          // Navigation to word detail/edit view
          onTap: () async{
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordDetailView(
                  label: null,
                  wordId: item.id,
                  wordName: item.name,
                  startWithEditView: true,
                  nodef: true,
                ),
              ),
            );
            //返回後刷新
            final _ = ref.refresh(outputListNotifierProvider(NotifierType.NoDefinition));
          },
          
          // Material 3 interactive styling
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before deleting a word
  /// 
  /// This method displays a Material 3 styled confirmation dialog
  /// to prevent accidental deletions and improve user experience.
  Future<bool> _showDeleteConfirmation(BuildContext context, String wordName) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Material 3 dialog styling
          backgroundColor: colorScheme.surface,
          surfaceTintColor: colorScheme.surfaceTint,
          
          // Dialog content
          icon: Icon(
            Icons.delete_outline,
            color: colorScheme.error,
            size: 24.0,
          ),
          title: Text(
            'Delete Word',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "$wordName"? This action cannot be undone.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          
          // Action buttons with Material 3 styling
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
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ) ?? false; // Return false if dialog is dismissed
  }
}