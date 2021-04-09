import 'package:flutter/material.dart';

class BondedDeviceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BondedDeviceView(),
    );
  }
}

class BondedDeviceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BondedDevice"),),
      body: SafeArea(
        child: Center(
          child: ElevatedButton(child: Text("Discovered Devices"), onPressed: () async {
            final String device = await Navigator.of(context).push(MaterialPageRoute(builder: (context){return ListDevice();}));

            if (device != null) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return DeviceView(device: device,);
              }));
            }
          },),
        ),
      ),
    );
  }
}

class ListDevice extends StatelessWidget {

  List<String> devices = ["Device One", "Device Two"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Device"),),
      body: SafeArea(
        child: ListView(
          children: devices.map((e) => buildDevice(context, e)).toList(),
        ),
      ),
    );
  }

  ListTile buildDevice(BuildContext context, String device){
    return ListTile(
      title: Text(device),
      onTap: (){
        Navigator.of(context).pop(device);
      },
    );
  }
}

class DeviceView extends StatelessWidget {
  final String device;
  DeviceView({this.device});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(device),),
      body: Center(
        child: Text(device),
      ),
    );
  }
}