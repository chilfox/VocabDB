import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:englishvocabdatabase/logic/service/exportService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/checkbox_label_widget.dart';

class ExportPage extends ConsumerStatefulWidget {
  const ExportPage({super.key});

  @override
  ConsumerState<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends ConsumerState<ExportPage> {
  final Set<int> selectedLabelIds = <int>{};
  final ExportService _exportService = ExportService();
  bool _isExporting = false;

  void _onLabelSelectionChanged(int labelId, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedLabelIds.add(labelId);
      } else {
        selectedLabelIds.remove(labelId);
      }
    });
  }

  Future<void> _exportSelectedLabels() async {
    print(selectedLabelIds.length);
    if (selectedLabelIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.eventNoSelectWord),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isExporting = true;
    });

    try {
      await _exportService.exportByLabel(selectedLabelIds.toList());
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.exportFileButton),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.eventError(error)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Label));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.exportBar, 
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        actions: selectedLabelIds.isNotEmpty 
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text(
                      '${selectedLabelIds.length}',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primaryContainer,
                  ),
                ),
              ]
            : null,
      ),

      body: SafeArea(
        child: asyncList.when(
          data: (list) {
            if (list.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.label_off,
                      size: 64.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'No labels available',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Add "No Label Word" option at the beginning like in label_list_view.dart
            final OutputListItem noLabel = OutputListItem(name: 'No Label Word', id: 1);
            if (list.isEmpty || list[0].id != 1) {
              list.insert(0, noLabel);
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 88.0), // Bottom padding for FAB
              itemCount: list.length,
              itemBuilder: (context, index) {
                final label = list[index];
                return CheckBoxLabelWidget(
                  label: label,
                  onSelectionChanged: _onLabelSelectionChanged,
                );
              },
            );
          },
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Loading labels...',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          error: (err, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.0,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16.0),
                Text(
                  AppLocalizations.of(context)!.eventError(err),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: selectedLabelIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isExporting ? null : _exportSelectedLabels,
              label: _isExporting 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Export'),
              icon: _isExporting ? null : const Icon(Icons.file_download),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 3.0,
            )
          : null,
    );
  }
}