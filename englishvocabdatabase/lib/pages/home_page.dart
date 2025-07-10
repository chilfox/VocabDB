import 'package:englishvocabdatabase/pages/TempPage/classify_page.dart';
import 'package:englishvocabdatabase/pages/settings_page.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/word_bank_page.dart';
import 'package:englishvocabdatabase/pages/word_detail_view.dart';
import '../logic/output/outputListNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/background/container.dart';
import 'package:englishvocabdatabase/language/generated/app_localizations.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  // current viewing
  int _currentPage = 0;

  // Title for the Page
  String _getPageTitle(BuildContext context, int index) {
    final loc = AppLocalizations.of(context)!;
    switch (index) {
      case 0: return loc.pageTitleWordBank;
      case 1: return loc.pageTitleTemporaryList;
      case 2: return loc.pageTitleSettings;
      default: return '';
    }
  }

  // Page List
  static const List<Widget> _pages = [
    WordBankPage(),
    ClassifyPage(),
    SettingsPage(),
  ];

  void _onBottomNavigationBarTapped(int index) {
    setState(() {
      if (_currentPage != 0 && index == 0) {
        ref.read(wordBankViewProvider.notifier).state = ChooseListView.label;
      }
      else if (index == 1) {
        ref.read(wordBankViewProvider.notifier).state = ChooseListView.nodef;
      }
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWordBankView = ref.watch(wordBankViewProvider);
    final log = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return BackgroundScaffold(
      // title
      appBar: AppBar(
        title: Text(
          _getPageTitle(context, _currentPage), 
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold, 
            fontSize: 32,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0, // Prevents elevation when scrolling
      ),

      // body
      body: _pages[_currentPage],

      // add button
      floatingActionButton: _buildFloatingActionButton(currentWordBankView, _currentPage, ref, context),

      // Enhanced bottom navigation bar with Material 3 theming
      bottomNavigationBar: Container(
        // Semi-transparent background with subtle border
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.8),
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_rounded), // Modern rounded icons
              label: log.browseIcon,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_rounded), 
              label: log.temporaryIcon,
            ), 
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), 
              label: log.settingsIcon,
            ),
          ],
          currentIndex: _currentPage,
          onTap: _onBottomNavigationBarTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Material 3 color scheme integration
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurfaceVariant,
          // Enhanced typography with proper font weights
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/// Builds a floating action button based on the current view and page
/// Returns null if not on the main word bank page (page 0)
Widget? _buildFloatingActionButton(ChooseListView view, final int currentPage, WidgetRef ref, BuildContext context) {
  // Only show FAB on the word bank page (index 0)
  if(currentPage != 0) {
    return null;
  }

  final log = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  
  // Create different FABs based on the current view (label vs word)
  switch(view) {
    case ChooseListView.label:
      // FAB for adding new labels
      return FloatingActionButton.extended(
        onPressed: () async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return addLabelDialog(context, ref);
            }
          ); 
        },
        label: Text(
          log.addLabel,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        icon: Icon(
          Icons.add_rounded,
          color: theme.colorScheme.onPrimaryContainer,
        ),
        // Material 3 styling with primaryContainer colors
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      );
    case ChooseListView.word:
      // FAB for adding new words
      return FloatingActionButton.extended(
        onPressed: () async {          
          return showDialog(
            context: context,
            builder: (BuildContext context){
              return addWordDialog(context, ref);
            }
          );
        },
        label: Text(
          log.addWordBar,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        icon: Icon(
          Icons.add_rounded,
          color: theme.colorScheme.onPrimaryContainer,
        ),
        // Material 3 styling with primaryContainer colors
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      );
    default:
      return null;
  }
}

/// Modern AlertDialog for adding new labels
AlertDialog addLabelDialog(BuildContext context, WidgetRef ref) {
  TextEditingController textController = TextEditingController();
  final service = ref.read(OutputListNotifierProvider(NotifierType.Label).notifier);
  final log = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  return AlertDialog(
    // Modern rounded corners for Material 3
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    backgroundColor: theme.colorScheme.surface,
    title: Text(
      log.createLabel,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    ),
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: log.typeLabelName,
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          // Modern rounded input field with proper theming
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
    ),
    actionsPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    actions: [
      // cancel button
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(log.eventCancel),
      ),
      const SizedBox(width: 8.0),
      // Primary action button with Material 3 FilledButton
      FilledButton(
        onPressed: () async {
          String labelName = textController.text.trim();
          // Input validation
          if (labelName.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(log.enterWord),
                behavior: SnackBarBehavior.floating, // Modern floating snackbar
              ),
            );
            return;
          }
          
          Navigator.of(context).pop();
          int newLabelId = await service.add(labelName);
          if (!context.mounted) return;
          if (newLabelId == -1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(log.eventAddFail),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(log.eventOk),
      ),
    ],
  );
}

/// Modern AlertDialog for adding new words
/// Includes input validation and navigation to word detail view after creation
AlertDialog addWordDialog(BuildContext context, WidgetRef ref) {
  TextEditingController textController = TextEditingController();
  final service = ref.read(OutputListNotifierProvider(NotifierType.NoDefinition).notifier);
  final log = AppLocalizations.of(context)!;
  final theme = Theme.of(context);

  return AlertDialog(
    // Modern rounded corners for Material 3
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    backgroundColor: theme.colorScheme.surface,
    title: Text(
      log.addNewWord,
      style: theme.textTheme.headlineSmall?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    ),
    content: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: log.typeWordName,
          hintStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          // Modern rounded input field with proper theming
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
        style: TextStyle(color: theme.colorScheme.onSurface),
        textCapitalization: TextCapitalization.words, // Auto-capitalize words
      ),
    ),
    actionsPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    actions: [
      // cancel button
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(log.eventCancel),
      ),
      const SizedBox(width: 8.0),
      // Primary action button with enhanced functionality
      FilledButton(
        onPressed: () async {
          String newWord = textController.text.trim();
          
          // Input validation
          if (newWord.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(log.enterWord),
                behavior: SnackBarBehavior.floating, // Modern floating snackbar
              ),
            );
            return;
          }
          
          // Close dialog first
          Navigator.of(context).pop();
          
          try {
            // Add the word to database
            int newWordId = await service.add(newWord);
            
            // Check if context is still valid
            if (!context.mounted) return;
            
            if (newWordId == -1) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(log.eventAddFail),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              // Navigate to WordDetailView for immediate editing
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordDetailView(
                    label: null, 
                    wordId: newWordId, 
                    wordName: newWord,
                    startWithEditView: true, // Start in edit mode
                    nodef: true,
                  )
                )
              );
            }
          } catch (error) {
            // Enhanced error handling with user-friendly messages
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(log.eventError(error.toString())),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(log.eventOk),
      ),
    ],
  );
}