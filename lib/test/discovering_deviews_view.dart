import 'package:flutter/material.dart';
import 'discovering_device_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './../BluetoothDeviceListEntry.dart';
import 'bonded_device_state.dart';

// discovering devices view
class DiscoveringDevicesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discovering Devices"),
        actions: [
          FittedBox(
            child: BlocBuilder<DiscoverDevicesCubit, DiscoverDevicesState>(builder: (context,state){
              return Container(
                margin: EdgeInsets.all(16.0),
                child: state.isDiscovering ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ) : Container(),
              );
            },),
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<DiscoverDevicesCubit, DiscoverDevicesState>(builder: (context,state){
          return ListView(
            children: buildListDevices(context, state.devices),
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