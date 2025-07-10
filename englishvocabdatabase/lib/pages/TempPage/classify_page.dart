/// Temporary/Classification page for managing words without definitions
/// Includes search functionality, quick add bar, and streamlined word list
import 'package:englishvocabdatabase/pages/TempPage/add_bar.dart';
import 'package:englishvocabdatabase/pages/TempPage/no_definition_list_view.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClassifyPage extends ConsumerStatefulWidget {
  const ClassifyPage({super.key});

  @override
  ClassifyPageState createState() => ClassifyPageState();
}

class ClassifyPageState extends ConsumerState<ClassifyPage> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Enhanced search bar with Material 3 styling
            const MySearchBar(),

            const SizedBox(height: 24.0), // Increased spacing for better visual rhythm
            
            // Quick add bar for temporary words
            const AddBar(),

            const SizedBox(height: 16.0), // Spacing between add bar and list

            // Expanded list view for words without definitions
            Expanded(child: const NoDefinitionListView()),
           ],
        ),
      ),
    );
  }
}