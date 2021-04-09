import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'MainPage.dart';
// test chat page
import 'test/test_chat_page.dart';
// test bonded device page
import 'test/test_bonded_devices.dart';
// test bluetooth state
import 'test/test_bluetooth_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: MainPage(),
      home:

      // MainPage(),

      BluetoothStateApp(),
      // BondedDeviceApp(),
      // ChatPage(
      //   server: BluetoothDevice(address: "AA", name: "Hai"),
      // ),
    );
  }
}
