import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:flutter/material.dart';

class CheckBoxLabelWidget extends StatefulWidget {
  final OutputListItem label;
  final Function(int labelId, bool isSelected) onSelectionChanged;
  
  const CheckBoxLabelWidget({
    super.key, 
    required this.label,
    required this.onSelectionChanged,
  });

  @override
  State<CheckBoxLabelWidget> createState() => _CheckBoxLabelWidgetState();
}

class _CheckBoxLabelWidgetState extends State<CheckBoxLabelWidget> {
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
            setState(() {
              isSelected = !isSelected;
            });
            widget.onSelectionChanged(widget.label.id, isSelected);
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
                      widget.onSelectionChanged(widget.label.id, isSelected);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                
                // Label indicator bar (similar to label_list_view.dart)
                Container(
                  width: 8.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                const SizedBox(width: 16.0),
                
                // Label content
                Expanded(
                  child: Text(
                    widget.label.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected 
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
