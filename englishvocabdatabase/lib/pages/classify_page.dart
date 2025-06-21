import 'package:englishvocabdatabase/pages/add_bar.dart';
import 'package:englishvocabdatabase/pages/no_definition_list_view.dart';
import 'package:englishvocabdatabase/pages/search_bar.dart';
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
            // Search bar
            const MySearchBar(),

            const SizedBox(height: 20,),
            
            const AddBar(),

            Expanded(child: NoDefinitionLIstView()),
           ],
        ),
      ),
    );
  }
}