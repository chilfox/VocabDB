import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/logic/output/outputListNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/logic/output/outputItem.dart';
import 'package:englishvocabdatabase/pages/BrowsePage/InLabelWordListPage/checkbox_label_widget.dart';

/// Import後的Label選擇頁面
/// 
/// 此頁面允許用戶為剛剛import的單字選擇要加入的label
/// UI設計完全參考ExportPage，提供一致的用戶體驗
class ImportLabelSelectionPage extends ConsumerStatefulWidget {
  // 接收import成功後的單字ID列表
  final List<int> importedWordIds;
  
  const ImportLabelSelectionPage({
    super.key,
    required this.importedWordIds,
  });

  @override
  ConsumerState<ImportLabelSelectionPage> createState() => _ImportLabelSelectionPageState();
}

class _ImportLabelSelectionPageState extends ConsumerState<ImportLabelSelectionPage> {
  // 儲存用戶選中的label ID集合，支援多選
  final Set<int> selectedLabelIds = <int>{};
  
  // 控制批量加入label操作的loading狀態
  bool _isProcessing = false;

  /// 處理label選擇狀態變更
  /// 當用戶勾選或取消勾選label時調用此方法
  void _onLabelSelectionChanged(int labelId, bool isSelected) {
    setState(() {
      if (isSelected) {
        // 用戶勾選了這個label，加入到選中集合
        selectedLabelIds.add(labelId);
      } else {
        // 用戶取消勾選，從選中集合移除
        selectedLabelIds.remove(labelId);
      }
    });
  }

  /// 批量將import的單字加入到選中的labels
  /// 參考word_detail_view中的addWordToLabel service方法
  Future<void> _addWordsToSelectedLabels() async {
    // 檢查是否有選中的label
    if (selectedLabelIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.eventNoSelectWord),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 開始處理，顯示loading狀態
    setState(() {
      _isProcessing = true;
    });

    try {
      // 取得outputListNotifier來執行addWordToLabel操作
      final notifier = ref.read(outputListNotifierProvider(NotifierType.Label).notifier);
      
      // 對每個選中的label，將所有imported的單字都加入該label
      for (int labelId in selectedLabelIds) {
        for (int wordId in widget.importedWordIds) {
          await notifier.addWordToLabel(wordId, labelId);
        }
      }
      
      if (!mounted) return;

      // 顯示成功訊息，告知用戶有多少個單字被加入到多少個label
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.importedWordIds.length} words added to ${selectedLabelIds.length} labels successfully',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // 完成後返回設定頁面
      Navigator.pop(context);
      
    } catch (error) {
      if (!mounted) return;
      
      // 處理錯誤情況，顯示錯誤訊息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add words to labels: ${error.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      // 無論成功或失敗，都要重置loading狀態
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // 監聽label列表資料，使用與ExportPage相同的provider
    final asyncList = ref.watch(outputListNotifierProvider(NotifierType.Label));
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      // AppBar設計與ExportPage一致
      appBar: AppBar(
        title: Text(
          'Add to Labels', // 可以後續加入本地化
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        // 當有選中的label時，顯示選中數量的chip
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
          // 成功載入label列表時的UI
          data: (list) {
            // 過濾掉第一個label ("No Label Word")，不顯示在選項中
            // 因為import的單字通常都需要分類到具體的label
            List<OutputListItem> filteredList = list.where((label) => label.id != 1).toList();
            
            if (filteredList.isEmpty) {
              // 當沒有可用的label時顯示空狀態
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
                    const SizedBox(height: 8.0),
                    Text(
                      'Create some labels first to organize your imported words',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // 使用ListView顯示過濾後的label列表
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8.0, bottom: 88.0), // 為FAB留出空間
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final label = filteredList[index];
                // 使用相同的CheckBoxLabelWidget來保持UI一致性
                return CheckBoxLabelWidget(
                  label: label,
                  onSelectionChanged: _onLabelSelectionChanged,
                );
              },
            );
          },
          // 載入中的狀態UI
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
          // 錯誤狀態UI
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
                  'Error loading labels: ${err.toString()}',
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

      // FloatingActionButton，與ExportPage設計一致
      floatingActionButton: selectedLabelIds.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _isProcessing ? null : _addWordsToSelectedLabels,
              label: _isProcessing 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Done'),
              icon: _isProcessing ? null : const Icon(Icons.check),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 3.0,
            )
          : null,
    );
  }
}
