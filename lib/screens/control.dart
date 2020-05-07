import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garagedooropener/classes/settings.dart';

import 'package:provider/provider.dart';
import '../classes/classes.dart';
import '../navbar.dart';

class ControlScreen extends StatefulWidget {
  static const String id = 'control_screen';
  @override
  _ControlScreenPage createState() => _ControlScreenPage();
}

class _ControlScreenPage extends State<ControlScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<FlutterBlueDevices>(context);
    var ds = Provider.of<Settings>(context);

    if (data.error.isNotEmpty) {
      return CupertinoAlertDialog(
        title: Text("Finner ikke device"),
        content: Text("Fant ikke devicet"),
        actions: [
          FlatButton(
            child: Text("OK",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            onPressed: () {
              data.clearError();
            },
          ),
        ],
      );
    } else {
      return Scaffold(
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            if (data.isScanning)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              Text(data?.connectedDevice?.name ?? "disconnected"),
            Center(
              child: RaisedButton(
                  onPressed: () {
                    if (data.connectedDevice == null) {
                      data.connect();
                    } else {
                      data.remove();
                    }
                  },
                  child: Text(data?.connectedDevice != null
                      ? "Disconnect"
                      : "Connect")),
            ),
          ],
        ),
      );
    }
  }
}
