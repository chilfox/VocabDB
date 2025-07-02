import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/pages/word_detail_view.dart';
import 'package:flutter/material.dart';

class CheckBoxWordWidget extends StatefulWidget {
  final OutputListItem word;
  final Function(int wordId, bool isSelected) onSelectionChanged;
  
  const CheckBoxWordWidget({
    super.key, 
    required this.word,
    required this.onSelectionChanged,
  });

  @override
  State<CheckBoxWordWidget> createState() => _CheckBoxWordWidgetState();
}

class _CheckBoxWordWidgetState extends State<CheckBoxWordWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListTile(
            leading: Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  isSelected = value ?? false;
                });
                widget.onSelectionChanged(widget.word.id, isSelected);
              },
            ),
            title: Text(widget.word.name),
            subtitle: Text(widget.word.chinese ?? ''),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordDetailView(
                    label: null, 
                    wordId: widget.word.id, 
                    startWithEditView: false, 
                    nodef: false,
                  ),
                ),
              );
            },
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
