import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:provider/provider.dart';
import '../classes/classes.dart';

class DevicesScreen extends StatefulWidget {
  static const String id = 'devices_screen';

  @override
  _DevicesScreen createState() => _DevicesScreen();
}

class _DevicesScreen extends State<DevicesScreen> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var eprovider = Provider.of<FlutterBlueDevices>(context);

    return Scaffold(
      body: eprovider.characteristic != null
          ? Center(
              child: Column(
                children: [
                  ServiceTile(
                    characteristic: eprovider.characteristic,
                  ),
                  Text(eprovider.isOpen ? "open" : "nope")
                ],
              ),
            )
          : Text("nada"),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  const ServiceTile({Key key, this.characteristic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("rewriting?");
    var eprovider = Provider.of<FlutterBlueDevices>(context);
    return Column(children: [
      RaisedButton(
        child: Text(characteristic.isNotifying ? "stop" : "start"),
        onPressed: () {
          characteristic.isNotifying
              ? eprovider.stopNotify()
              : eprovider.startNotify();
        },
      ),
      Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: RaisedButton(
            padding: EdgeInsets.all(23.0),
            onPressed: () async {
              try {
                eprovider.setOpen();
                eprovider.updateIsOpen();
              } catch (e) {
                print(e);
              }
            },
            child: Text("Open garage", style: TextStyle(fontSize: 50.0)),
          ),
        ),
      ),
    ]);
  }
}
