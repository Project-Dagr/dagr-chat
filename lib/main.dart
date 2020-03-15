import 'package:flutter/material.dart';
import './BLEDevicePage.dart';

import './MainPage.dart';

void main() => runApp(new ExampleApplication());

class ExampleApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FindDevicesScreen()
    );
  }
}
