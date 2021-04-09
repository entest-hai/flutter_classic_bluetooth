import 'package:flutter/material.dart';
import 'bonded_devices_cubit.dart';
import 'bonded_device_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './../BluetoothDeviceListEntry.dart';

class BondedDevicesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bonded Devices"),),
      body: SafeArea(
        child: BlocBuilder<BondedDevicesCubit, List<DeviceWithAvailability>>(builder: (context,devices){
          return ListView(
            children: buildListDevices(context, devices),
          );
        },),
      ),
    );
  }

  List<Card> buildListDevices(BuildContext context, List<DeviceWithAvailability> devices){
    return devices.map((device) =>  Card(
      child: BluetoothDeviceListEntry(
        device: device.device,
        rssi: device.rssi,
        enabled: device.availability == DeviceAvailability.yes,
        onTap: (){
          Navigator.of(context).pop(device);
        },
      ),
    )).toList();
  }
}
