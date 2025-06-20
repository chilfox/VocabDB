import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LabelListView extends StatefulWidget {
  const LabelListView({super.key});

  @override
  State<LabelListView> createState() => _LabelListViewState();
}

class _LabelListViewState extends State<LabelListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return LabelWidget(context, index);
      },
    );
  }
}

Widget LabelWidget(BuildContext context, int index) {
  final ThemeData theme = Theme.of(context);
  final double height = 54;
  final double RoundRectangularBorder = height/2;

  return Column(
    children: [
      Container(
        height: height,
        padding: EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RoundRectangularBorder),
          color: theme.colorScheme.secondary,
        ),
        child: Slidable(
          // key
          key: ValueKey(index),
        
          // slide animation
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                borderRadius: BorderRadius.circular(RoundRectangularBorder),
                onPressed:(context) {
                  print("delete word");
                },
                backgroundColor: theme.colorScheme.error,
                icon: Icons.delete,
              ),
            ],
          ),
          child: ListTile(
            title: Text('Label', style: TextStyle(color: theme.primaryColor),),
            onTap: () {
              print("I'm Tapped");
            },
          ),
        ),
      ),
      
      SizedBox(height: 20.0,),
    ],
  );
}