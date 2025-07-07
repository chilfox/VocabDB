import 'package:flutter/material.dart';

/// 一个带下拉建议列表的 TextField 组件
class SuggestionTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final List<String> suggestions;
  final int maxLines;
  final VoidCallback onTap;
  final void Function(String) onSelected;
  final TextStyle? style;         // 這裡是 textStyle，不是 style
  final InputDecoration? decoration;

  const SuggestionTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.suggestions,
    required this.onTap,
    required this.onSelected,
    this.maxLines = 1,
    this.style,
    this.decoration,
  }) : super(key: key);

  @override
  State<SuggestionTextField> createState() => _SuggestionTextFieldState();
}

class _SuggestionTextFieldState extends State<SuggestionTextField> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          style: widget.style, // 這裡要用 style，且從 widget.textStyle 傳入
          decoration: widget.decoration ??
              InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(),
              ),
          onTap: () {
            widget.onTap();
            setState(() => _show = true);
          },
        ),
        if (_show && widget.suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.suggestions.length,
              itemBuilder: (_, i) {
                final s = widget.suggestions[i];
                return ListTile(
                  title: Text(s, style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    widget.onSelected(s);
                    setState(() => _show = false);
                  },
                );
              },
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                color: Colors.white24,
                indent: 16,
                endIndent: 16,
              ),
            ),
          ),
      ],
    );
  }
}
