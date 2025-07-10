import 'package:englishvocabdatabase/language/generated/app_localizations_en.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/in_label_word_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/language/generated/app_localizations.dart';

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
          return Center(child: Text(AppLocalizations.of(context)!.labelListEmpty));
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
      error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.eventError(err)))
    );
  }
}

Widget labelWidget(BuildContext context, OutputListItem item, OutputListNotifier service) {
  final ThemeData theme = Theme.of(context);
  
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Slidable(
        key: ValueKey(item.id),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              flex: 1,
              onPressed: (context) async {
                bool success = await service.delete(item.id);
                if (!context.mounted) return;
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.eventDeleteFail),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
              icon: Icons.delete_outline,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InLabelWordListPage(label: item),
                  ),
                );
              },
              child: Container(
                constraints: const BoxConstraints(minHeight: 64.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Container(
                      width: 8.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        item.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}