import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WordListView extends StatefulWidget {
  const WordListView({super.key});

  @override
  State<WordListView> createState() => _WordListViewState();
}

class _WordListViewState extends State<WordListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        return vocabularyWordWidget(context, index);
      },
    );
  }
}

Widget vocabularyWordWidget(BuildContext context, int index) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Slidable(
          // key
          key: ValueKey(index),
        
          // slide animation
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed:(context) {
                  print("delete word");
                },
                backgroundColor: Theme.of(context).colorScheme.error,
                icon: Icons.delete,
              ),
            ],
          ),
          child: ListTile(
            title: Text('Word'),
            subtitle: Text('Definition'),
            onTap: () {
              print("I'm Tapped");
            },
          ),
        ),
      ),

      // Divider
      const Divider(
        height: 1.0, // 分隔線的高度 (實際的線條厚度)
        thickness: 1.0, // 分隔線的厚度 (實際的線條厚度，推薦使用這個)
        indent: 16.0, // 線條左邊的縮排
        endIndent: 16.0, // 線條右邊的縮排
        color: Color.fromARGB(255, 107, 104, 104), // 線條的顏色
      ),
    ],
  );
}