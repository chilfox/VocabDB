import 'package:flutter/material.dart';
import 'package:englishvocabdatabase/background/manager.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50.0,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10.0),
              child: const Text(
                'Setting 1',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Container(
              height: 50.0,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10.0),
              child: const Text(
                'Setting 2',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final file = await BackgroundManager.pickAndSaveBackgroundImage();
                if (file != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('背景圖片已更新！')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('沒有選擇圖片或權限不足')),
                  );
                }
              },
              child: const Text('選擇背景圖片'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () async {
                await BackgroundManager.clearBackgroundImage();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('背景圖片已清除，將恢復預設背景。')),
                );
              },
              child: const Text('清除背景圖片'),
            ),
          ],
        ),
      ),
    );
  }
}
