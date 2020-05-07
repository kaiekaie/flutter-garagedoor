import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import './classes/classes.dart';

class Tabs extends StatefulWidget {
  final IconData icon;
  Tabs({this.icon});
  @override
  _Tabs createState() => _Tabs();
}

class _Tabs extends State<Tabs> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var device = Provider.of<FlutterBlueDevices>(context);

    return Tab(
        icon: Icon(this.widget.icon,
            color:
                device.connectedDevice != null ? Colors.white : Colors.grey));
  }
}
