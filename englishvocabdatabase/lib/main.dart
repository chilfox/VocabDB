import 'package:englishvocabdatabase/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/share/share.dart';
import 'package:englishvocabdatabase/share/processShare.dart';
import 'package:englishvocabdatabase/share/observer.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //handle share text when open the app
  await ShareHandler.instance.init();
  ShareHandler.instance.processPending((text){
    //process the shared text
    debugPrint('處理分享文字: $text');
    ShareProcessor.processText(text);
  });

  runApp(const ProviderScope(child: MyApp()));
  
  //前台處理分享字串
  final share_observer = ShareObserver();
  share_observer.init();
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