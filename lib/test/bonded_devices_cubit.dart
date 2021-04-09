import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// bonded device state
import 'bonded_device_state.dart';

class BondedDevicesCubit extends Cubit<List<DeviceWithAvailability>> {
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  List<DeviceWithAvailability> devices = List<DeviceWithAvailability>();
  FlutterBluetoothSerial _flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  BondedDevicesCubit() : super([]);

  // get bonded devices
  Future<void> getBondedDevices() async {
    await _flutterBluetoothSerial.getBondedDevices().then((List<BluetoothDevice> bondedDevices){
      devices = bondedDevices.map((device) => DeviceWithAvailability(device, DeviceAvailability.yes)).toList();
    });
    emit(devices);
    // startDiscovery();
  }

  //
  void startDiscovery(){
    _discoveryStreamSubscription = _flutterBluetoothSerial.startDiscovery().listen((r) {
      Iterator i = devices.iterator;
      while (i.moveNext()) {
        var _device = i.current;
        if (_device.device == r.device) {
          _device.availability = DeviceAvailability.yes;
          _device.rssi = r.rssi;
        }
      }
    });

    _discoveryStreamSubscription.onDone(() {
      emit(devices);
    });
  }

}