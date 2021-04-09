import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// bonded device state
import 'bonded_device_state.dart';

class DiscoverDevicesState {
  final bool isDiscovering;
  List<DeviceWithAvailability> devices;
  DiscoverDevicesState({
    this.isDiscovering=true,
    this.devices});
}

class DiscoverDevicesCubit extends Cubit<DiscoverDevicesState> {
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;

  FlutterBluetoothSerial _flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  DiscoverDevicesCubit() : super(DiscoverDevicesState(devices: []));

  void startDiscovery(){
    List<DeviceWithAvailability> devices = [];
    _discoveryStreamSubscription = _flutterBluetoothSerial.startDiscovery().listen((r) {
      print(r.device.toString());
      devices.add(DeviceWithAvailability(r.device, DeviceAvailability.yes, r.rssi));
      emit(DiscoverDevicesState(devices: devices));
    }
    );

    _discoveryStreamSubscription.onDone(() {
      print(devices.toString());
      emit(DiscoverDevicesState(devices: devices, isDiscovering: false));
      _discoveryStreamSubscription.cancel();
    });
  }
}