import 'dart:io';
import 'package:flutter/material.dart';
import 'manager.dart';

class BackgroundScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const BackgroundScaffold({
    Key? key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<BackgroundScaffold> createState() => _BackgroundScaffoldState();
}

class _BackgroundScaffoldState extends State<BackgroundScaffold> {
  File? _backgroundImageFile;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    BackgroundManager.backgroundVersion.addListener(_onBackgroundChanged);
  }

  @override
  void dispose() {
    BackgroundManager.backgroundVersion.removeListener(_onBackgroundChanged);
    super.dispose();
  }

  void _onBackgroundChanged() {
    _loadBackgroundImage();
  }

  Future<void> _loadBackgroundImage() async {
    final image = await BackgroundManager.getBackgroundImage();
    setState(() {
      _backgroundImageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景圖片層
        if (_backgroundImageFile != null)
          Positioned.fill(
            child: Image.file(
              _backgroundImageFile!,
              fit: BoxFit.cover,
            ),
          ),

        // 深色遮罩層
        Positioned.fill(
          child: Container(
            color: Colors.black.withAlpha((0.7 * 255).round()),
          ),
        ),

        // Scaffold 上層
        Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: widget.appBar,
          body: widget.body,
          floatingActionButton: widget.floatingActionButton,
          bottomNavigationBar: widget.bottomNavigationBar,
        ),
      ],
    );
  }
}
