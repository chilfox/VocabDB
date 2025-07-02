import 'package:englishvocabdatabase/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/share/share.dart';
import 'package:englishvocabdatabase/share/processShare.dart';
import 'package:englishvocabdatabase/share/observer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // final dataList = await ShareHandler.instance.getAllStoredData();
  // debugPrint('get $dataList');

  //前台處理分享字串
  final share_observer = ShareObserver();
  share_observer.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}