import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'MainPage.dart';
import 'test/test_chat_page.dart';
import 'test/test_bonded_devices.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: MainPage(),
      home: BondedDeviceApp(),
      // ChatPage(
      //   server: BluetoothDevice(address: "AA", name: "Hai"),
      // ),
    );
  }
}
