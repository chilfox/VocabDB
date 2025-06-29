import 'package:englishvocabdatabase/pages/TempPage/classify_page.dart';
import 'package:englishvocabdatabase/pages/settings_page.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/word_bank_page.dart';
import 'package:englishvocabdatabase/pages/word_detail_view.dart';
import '../logic/output/outputListNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  // current viewing
  int _currentPage = 0;

  // Title for the Page
  static const List<String> _pageTitles = [
    'Word Bank',
    'Temporary List',
    'Import & Export',
    'Settings'
  ];
  
  // Page List
  static const List<Widget> _pages = [
    WordBankPage(),
    ClassifyPage(),
    SettingsPage(),
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

    return Scaffold(
      // title
      appBar: AppBar(
        title: Text(_pageTitles[_currentPage], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
        centerTitle: false,
        elevation: 0,
      ),

      // body
      body: _pages[_currentPage],

      // add button
      floatingActionButton: _buildFloatingActionButton(currentWordBankView, _currentPage, ref, context),

      // bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Temporary'), 
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _currentPage,
        onTap: _onBottomNavigationBarTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

Widget? _buildFloatingActionButton(ChooseListView view, final int currentPage, WidgetRef ref, BuildContext context) {
  if(currentPage != 0) {
    return null;
  }

  switch(view) {
    case ChooseListView.label:
      return FloatingActionButton.extended(
        onPressed: () async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return addLabelDialog(context, ref);
            }
          ); 
        },
        label: const Text('Add Label'),
        icon: const Icon(Icons.add),
      );
    case ChooseListView.word:
      return FloatingActionButton.extended(
        onPressed: () async {          
          return showDialog(
            context: context,
            builder: (BuildContext context){
              return addWordDialog(context, ref);
            }
          );
        },
        label: const Text('Add Word'),
        icon: const Icon(Icons.add),
      );
    default:
      return null;
  }
}

AlertDialog addLabelDialog(BuildContext context, WidgetRef ref) {
  TextEditingController textController = TextEditingController();
  final service = ref.read(OutputListNotifierProvider(NotifierType.Label).notifier);

  return AlertDialog(
    title: Text('Create New Label'),
    content: TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: 'Type in new label name',
        border: OutlineInputBorder(),
      ),
    ),
    actions: [
      // cancel button
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text('Cancel'),
      ),
      // okay button
      TextButton(
        onPressed: () async {
          Navigator.of(context).pop();
          int newLabelId = await service.add(textController.text);
          if (!context.mounted) return;
          if (newLabelId == -1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add Failed')),
            );
          }
        },
        child: Text('OK'),
      ),
    ],
  );
}

AlertDialog addWordDialog(BuildContext context, WidgetRef ref) {
  TextEditingController textController = TextEditingController();
  final service = ref.read(OutputListNotifierProvider(NotifierType.NoDefinition).notifier);

  return AlertDialog(
    title: Text('Add New Word'),
    content: TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: 'Type in new word',
        border: OutlineInputBorder(),
      ),
    ),
    actions: [
      // cancel button
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text('Cancel'),
      ),
      // okay button
      TextButton(
        onPressed: () async {
          String newWord = textController.text.trim();
          
          // Validate input
          if (newWord.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a word')),
            );
            return;
          }
          
          // Close dialog first
          Navigator.of(context).pop();
          
          try {
            // Add the word
            int newWordId = await service.add(newWord);
            
            // Check if context is still valid
            if (!context.mounted) return;
            
            if (newWordId == -1) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add Failed')),
              );
            } else {
              // Navigate to WordDetailView
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordDetailView(
                    label: null, 
                    wordId: newWordId, 
                    startWithEditView: true,
                    nodef: true,
                  )
                )
              );
            }
          } catch (error) {
            // Handle any errors that might occur
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${error.toString()}')),
            );
          }
        },
        child: Text('OK'),
      ),
    ],
  );
}