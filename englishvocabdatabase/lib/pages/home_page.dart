import 'package:englishvocabdatabase/pages/settings_page.dart';
import 'package:englishvocabdatabase/pages/word_bank_page.dart';
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
    'Create and Classify',
    'Import & Export',
    'Settings'
  ];
  
  // Page List
  static const List<Widget> _pages = [
    WordBankPage(),
    SettingsPage(),
    SettingsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
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
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'), 
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Tools'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _currentPage,
        onTap: _onItemTapped,
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
          final service = ref.read(outputListNotifierProvider(NotifierType.Label).notifier);
          bool success = await service.add('New Item');
          if (!context.mounted) return;
          if (!success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add failed')),
            );
          }
        },
        label: const Text('Add Label'),
        icon: const Icon(Icons.add),
      );
    
    case ChooseListView.word:
      return FloatingActionButton.extended(
        onPressed: () {
          print("Add Word按鈕被按下了");
        },
        label: const Text('Add Word'),
        icon: const Icon(Icons.add),
      );
  }
}