// testpage.dart

import 'package:flutter/material.dart';
import 'file_upload_helper.dart'; // 假設 pickAndUploadFile 在這個檔案
import 'dart:io'; // 用於 File 類型
import 'package:file_picker/file_picker.dart'; // 因為 pickAndUploadFile 在這裡面被調用

// ============================== 新增的啟動程式碼 ==============================
void main() {
  // 這是關鍵！確保 Flutter 框架與原生平台綁定在任何插件使用前被初始化。
  // 'file_picker' 是一個插件，它需要這個初始化。
  WidgetsFlutterBinding.ensureInitialized();
  
  // 啟動應用程式，並將 UploadScreen 作為根 Widget。
  // UploadScreen 需要被包裹在 MaterialApp 中才能正常工作。
  runApp(const MyAppForTestPage());
}

// 為 testpage.dart 創建一個獨立的應用程式 Wrapper
class MyAppForTestPage extends StatelessWidget {
  const MyAppForTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '測試頁面上傳範例', // 應用程式的標題
      theme: ThemeData(
        primarySwatch: Colors.blue, // 設定應用程式的主題顏色
      ),
      home: const UploadScreen(), // 將你的 UploadScreen 設定為這個測試應用程式的首頁
    );
  }
}
// ========================================================================


// 你的 UploadScreen 程式碼 (與之前提供的相同)
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _uploadedFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('檔案上傳範例'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                File? file = await pickAndUploadFile(); // 呼叫你的上傳函數
                if (file != null) {
                  setState(() {
                    _uploadedFileName = file.path.split('/').last; // 顯示檔案名稱
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已選擇檔案: $_uploadedFileName')),
                  );
                  // 在這裡可以呼叫解析 CSV 的函數：
                  // await parseCsvFile(file);
                }
              },
              child: const Text('選擇並上傳檔案'),
            ),
            if (_uploadedFileName != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('已選擇檔案: $_uploadedFileName'),
              ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------
// file_upload_helper.dart (確保這個檔案存在且包含 pickAndUploadFile 函數)
// 這是之前提供的 pickAndUploadFile 函數內容
/*
import 'package:file_picker/file_picker.dart';
import 'dart:io';

Future<File?> pickAndUploadFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile platformFile = result.files.first;
      File selectedFile = File(platformFile.path!);
      print('使用者選擇的檔案名稱: ${platformFile.name}');
      print('檔案路徑: ${platformFile.path}');
      print('檔案大小: ${platformFile.size} bytes');
      return selectedFile;
    } else {
      print('使用者取消了檔案選擇');
      return null;
    }
  } catch (e) {
    print('選擇檔案時發生錯誤: $e');
    return null;
  }
}
*/