import 'package:englishvocabdatabase/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englishvocabdatabase/share/observer.dart';
import 'dart:io';
import 'language/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'language/provider/locale_provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  //前台處理分享字串
  if (Platform.isAndroid) {
    final share_observer = ShareObserver();
    share_observer.init();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      locale: locale,                             // 指定語系
      localizationsDelegates: const [             // 多語系代理
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,//語言清單
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}