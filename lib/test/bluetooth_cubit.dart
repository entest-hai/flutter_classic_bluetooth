import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bluetooth State

// Bluetooth Cubit
class BluetoothCubit extends Cubit<BluetoothState> {
  FlutterBluetoothSerial _flutterBluetoothSerial = FlutterBluetoothSerial.instance;

  BluetoothCubit() : super(BluetoothState.UNKNOWN);

  void checkBluetoothState() {
    _flutterBluetoothSerial.state.then((state){
      print(state);
      emit(state);
    });
  }

  Future<void> requestEnable() async {
    print("request enable");
    await _flutterBluetoothSerial.requestEnable();
    checkBluetoothState();
  }

  Future<void> requestDisable() async {
    print("request disable");
    await _flutterBluetoothSerial.requestDisable();
    checkBluetoothState();
  }

  Future<void> openSettings() async {
    await _flutterBluetoothSerial.openSettings();

  }

}