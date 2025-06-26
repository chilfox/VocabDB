import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/in_label_word_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';

class LabelListView extends ConsumerStatefulWidget {
  const LabelListView({super.key});

  @override
  ConsumerState<LabelListView> createState() => _LabelListViewState();
}

class _LabelListViewState extends ConsumerState<LabelListView> {
  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Label));
    final service = ref.read(outputListNotifierProvider(NotifierType.Label).notifier);

    return asyncList.when(
      data: (list) {
        if (list.isEmpty){
          return const Center(child: Text("Label List is Empty"));
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return labelWidget(context, item, service);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

Widget labelWidget(BuildContext context, OutputListItem item, OutputListNotifier service) {
  final ThemeData theme = Theme.of(context);
  final double height = 54;
  final double roundRectangularBorder = height/2;
  
  return Column(
    children: [
      Container(
        height: height,
        padding: EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(roundRectangularBorder),
          color: theme.colorScheme.secondary,
        ),
        child: Slidable(
          // key
          key: ValueKey(item.id),
        
          // slide animation
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                borderRadius: BorderRadius.circular(roundRectangularBorder),
                onPressed: (context) async {
                  bool success = await service.delete(item.id);
                  if (!context.mounted) return;
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Delete Failed')),
                    );
                  }
                },
                backgroundColor: theme.colorScheme.error,
                icon: Icons.delete,
              ),
            ],
          ),
          child: ListTile(
            title: Text(item.name, style: TextStyle(color: theme.primaryColor),),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InLabelWordListPage(label: item)),
              );
            },
          ),
        ),
      ),
      
      SizedBox(height: 20.0,),
    ],
  );
}