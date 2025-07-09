import 'package:flutter/material.dart';
import 'package:englishvocabdatabase/background/manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/language/generated/app_localizations.dart';
import 'package:englishvocabdatabase/language/provider/locale_provider.dart';
import '../import_export/import.dart';

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
                final messenger = ScaffoldMessenger.of(context);
                final loc = AppLocalizations.of(context)!;
                final file = await BackgroundManager.pickAndSaveBackgroundImage();
                if (file != null) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(loc.doneUpdateBackground)),
                  );
                } else {
                  messenger.showSnackBar(
                    SnackBar(content: Text(loc.eventBackgroundFail)),
                  );
                }
              },
              child: Text(AppLocalizations.of(context)!.buttonChooseBackground),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final loc = AppLocalizations.of(context)!;
                await BackgroundManager.clearBackgroundImage();
                messenger.showSnackBar(
                  SnackBar(content: Text(loc.doneClearBackground)),
                );
              },
              child: Text(AppLocalizations.of(context)!.buttonClearBackground),
            ),

            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final loc = AppLocalizations.of(context)!;
                return ElevatedButton(
                  onPressed: () => toggleLocale(ref),
                  child: Text(loc.buttonChangeLanguage),
                );
              },
            ),
            ElevatedButton(
              onPressed: () async {
                String? content = await pickAndUploadFile(); // 呼叫你的上傳函數
                if (content != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已選擇檔案')),
                  );
                  var csvlist = await parseCsvString(content);
                  int boolean = await convertCsvToWords(csvlist);
                  if(boolean == 0){
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('檔案內容是空的，請重新選擇')),
                    );
                  }
                  else if(boolean == -1){
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('檔案內容沒有name的欄位，請重新選擇')),
                    );
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('檔案內容已經成功上傳')),
                    );
                  }
                }
              },
              child: const Text('選擇並上傳檔案，檔案裡面的標頭只會讀取name, definition 和 chinese'),
            ),
          ],
        ),
      ),
    );
  }
}