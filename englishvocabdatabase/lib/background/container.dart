import 'dart:io';
import 'package:flutter/material.dart';
import 'manager.dart';

class BackgroundContainer extends StatefulWidget {
  final Widget child;

  const BackgroundContainer({super.key, required this.child});

  @override
  State<BackgroundContainer> createState() => _BackgroundContainerState();
}

class _BackgroundContainerState extends State<BackgroundContainer> {
  File? _backgroundImageFile;

  @override
  void initState() {
    super.initState();
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
    return Container(
      decoration: BoxDecoration(
        image: _backgroundImageFile != null
            ? DecorationImage(
                image: FileImage(_backgroundImageFile!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: widget.child,
    );
  }
}
