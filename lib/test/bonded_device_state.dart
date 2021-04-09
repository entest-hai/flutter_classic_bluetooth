import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

enum DeviceAvailability {
  no,
  maybe,
  yes,
}
class DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  DeviceAvailability availability;
  int rssi;
  DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}