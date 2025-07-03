import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/pages/word_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class InLabelVocabularyWordWidget extends StatelessWidget {
  final OutputListItem word;
  final OutputListNotifier service;
  final OutputListItem label;
  
  const InLabelVocabularyWordWidget({super.key, required this.label, required this.word, required this.service});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Slidable(
            // key
            key: ValueKey(word.id),
          
            // slide animation
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    bool success = await service.delete(word.id);
                    if (!context.mounted) return;
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delete Failed')),
                      );
                    }
                  },
                  backgroundColor: Theme.of(context).colorScheme.error,
                  icon: Icons.delete,
                ),
              ],
            ),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    
                  },
                )
              ],
            ),
            child: ListTile(
              title: Text(word.name),
              subtitle: Text(word.chinese ?? ''),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WordDetailView(label: null, wordId: word.id, startWithEditView: false, nodef: false,)),
                );
              },
            ),
          ),
        ),

        // Divider
        const Divider(
          height: 1.0, 
          thickness: 1.0,
          indent: 16.0, 
          endIndent: 16.0, 
          color: Color.fromARGB(255, 107, 104, 104), 
        ),
      ],
    );
  }
}