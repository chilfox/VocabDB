import 'package:englishvocabdatabase/pages/word_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';


class NoDefinitionListView extends ConsumerStatefulWidget {
  const NoDefinitionListView({super.key});

  @override
  ConsumerState<NoDefinitionListView> createState() => _NoDefinitionListViewState();
}

class _NoDefinitionListViewState extends ConsumerState<NoDefinitionListView> {
  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.NoDefinition));
    final service = ref.read(outputListNotifierProvider(NotifierType.NoDefinition).notifier);

    return asyncList.when(
      data: (list) {
        if (list.isEmpty){
          return const Center(child: Text("Temporary List is Empty"));
        }
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return noDefinitionWidget(context, item, service);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

Widget noDefinitionWidget(BuildContext context, OutputListItem item, OutputListNotifier service) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Slidable(
          // key
          key: ValueKey(item.id),
        
          // slide animation
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) async {
                  bool success = await service.delete(item.id);
                  if(!context.mounted) return;
                  if(!success){
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
          child: ListTile(
            title: Text(item.name),
            onTap: () {
              // open word edit page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WordDetailView(label: null, wordId: item.id, wordName: item.name, startWithEditView: true, nodef: true,)),
              );
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