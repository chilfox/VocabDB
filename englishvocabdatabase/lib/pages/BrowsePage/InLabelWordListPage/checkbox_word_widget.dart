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
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Material(
        elevation: isSelected ? 2.0 : 0.0,
        borderRadius: BorderRadius.circular(12.0),
        color: isSelected 
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
            : theme.colorScheme.surface,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordDetailView(
                  label: null, 
                  wordId: widget.word.id, 
                  wordName: widget.word.name,
                  startWithEditView: false, 
                  nodef: false,
                ),
              ),
            );
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 72.0),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Material 3 styled checkbox
                Material(
                  color: Colors.transparent,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        isSelected = value ?? false;
                      });
                      widget.onSelectionChanged(widget.word.id, isSelected);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                
                // Word icon indicator (consistent with vocabulary_word_widget.dart)
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    Icons.text_fields_rounded,
                    color: isSelected 
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSecondaryContainer,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                
                // Word content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Word name
                      Text(
                        widget.word.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected 
                              ? theme.colorScheme.onPrimaryContainer
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (widget.word.chinese != null && widget.word.chinese!.isNotEmpty) ...[
                        const SizedBox(height: 4.0),
                        // Chinese translation
                        Text(
                          widget.word.chinese!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isSelected 
                                ? theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
