import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsetsGeometry.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50.0,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Setting 1',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Container(
              height: 50.0,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Setting 2',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}