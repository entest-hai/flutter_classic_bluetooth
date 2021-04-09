import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// bluetooth cubit
import 'bluetooth_cubit.dart';
// bonded devices cubit
import 'bonded_devices_cubit.dart';
// boded device state
import 'bonded_device_state.dart';
import 'discovering_device_cubit.dart';
// device entity
import './../BluetoothDeviceListEntry.dart';

class BluetoothStateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(providers: [
        BlocProvider(create: (context) => BluetoothCubit()..checkBluetoothState()),
        BlocProvider(create: (context) => BondedDevicesCubit()),
        BlocProvider(create: (context) => DiscoverDevicesCubit()),
      ],
      child: SerialBluetoothNav(),
      ),
    );
  }
}

class SerialBluetoothNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [MaterialPage(child: BluetoothStateView())],
      onPopPage: (route, result){
        return route.didPop(result);
      },
    );
  }
}

class BluetoothStateView extends StatefulWidget {
   @override
  State<StatefulWidget> createState() {
    return _BluetoothState();
  }
}

class _BluetoothState extends State<BluetoothStateView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bluetooth State"),),
      body: SafeArea(
        child: Container(
          child: ListView(
            children: [
              Divider(),
              ListTile(title: Text("General Bluetooth"),),
              
              // Bluetooth state
              BlocBuilder<BluetoothCubit, BluetoothState>(builder: (context, state){
                return SwitchListTile(
                    title: Text("Enable Bluetooth"),
                    value: state.isEnabled,
                    onChanged: (bool value) async {
                      print(value);
                      if (value) {
                        await BlocProvider.of<BluetoothCubit>(context).requestEnable();
                      } else {
                        await BlocProvider.of<BluetoothCubit>(context).requestDisable();
                      }
                    }
                );
              }
              ),
            
             //  Open setting 
             BlocBuilder<BluetoothCubit, BluetoothState>(builder: (context,state){
               return  ListTile(
                 title: Text("Bluetooth Status"),
                 subtitle: Text(state.toString()),
                 trailing: ElevatedButton(
                   child: Text("Settings"),
                   onPressed: (){
                      BlocProvider.of<BluetoothCubit>(context).openSettings();
                   },
                 ),
               );
             }),
              
            // Local adapter address
            BlocBuilder<BluetoothCubit,BluetoothState>(builder: (context,state){
              return ListTile(
                title: Text("Local adapter address"),
                subtitle: Text("Address"),
              );
            }),

            // Local adapter name
              BlocBuilder<BluetoothCubit,BluetoothState>(builder: (context,state){
                return ListTile(
                  title: Text("Local adapter name"),
                  subtitle: Text("Name"),
                );
              }),

            // Make me discoverable to others devices
            ListTile(
              title: Text("Discoverable"),
              subtitle: Text("PsychoX-Luna"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(value: true, onChanged: null),
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
                  IconButton(onPressed: () async {
                    print('Discoverable requested ');
                    // FlutterBlutoothSerial requestDiscoverable(60)


                  }, icon: Icon(Icons.refresh)),
                ],
              ),
            ),

          // Divider
          Divider(),

          // Devices discovery and connection
          ListTile(
            title: Text("Devices discovery and connection"),
          ),
          SwitchListTile(
              title: Text("Auto-try specific pin when pairing"),
              subtitle: Text("Pin 1234"),
              value: true,
              onChanged: (bool value){
                // pair request
              },
              ),

          // Show device and RSSI and MAC
          ListTile(
            title: ElevatedButton(
              child: Text("Explore discovered devices"),
              onPressed: () async {
                // Push to list devices view and return selectedDevice
                BlocProvider.of<DiscoverDevicesCubit>(context).startDiscovery();
                Navigator.of(context).push(MaterialPageRoute(builder: (context){return DiscoveringDeviewView();}));
                // Check selectedDevice and go to selectedDeviceView
              },
            ),
          ),

          // Connect to paired devices
          ListTile(
            title: ElevatedButton(child: Text("Connect to paired device to chat"), onPressed: () async {

              BlocProvider.of<BondedDevicesCubit>(context).getBondedDevices();
              // Push to list of device and selected device
              Navigator.of(context).push(MaterialPageRoute(builder: (context){return BondedDevicesView();}));

              // Show selected device view
            },),
          ),

          // Divider
          Divider(),

          // Multiple connection example
          ListTile(
            title: Text("Multiple connections example"),
          ),

          ListTile(
            title: ElevatedButton(
              child: Text("Disconnect and stop background collecting"),
              onPressed: (){},

            ),
          ),
          ListTile(
            title: ElevatedButton(
              child: const Text("View background collected data"),
              onPressed: (){

              },
            ),
          )

            ],
          ),
        ),
      ),
    );
  }
}


// discovering devices view
class DiscoveringDeviewView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Discovering Devices"),),
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



// SelectedBondedDeviceView
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

