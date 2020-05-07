import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'classes/classes.dart';
import 'classes/settings.dart';
import 'navbar.dart';
import './screens/control.dart';
import './screens/devices.dart';

class MainScreen extends StatefulWidget {
  final TabController tabController;
  MainScreen({this.tabController});
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<Settings>(context, listen: false).getDevice();
    Provider.of<FlutterBlueDevices>(context, listen: false).connect();
    Provider.of<FlutterBlueDevices>(context, listen: false).listen();
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<FlutterBlueDevices>(context);
    this.widget.tabController.addListener(() {
      if (data.connectedDevice == null) {
        this.widget.tabController.animateTo(0);
      }
    });

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: this.widget.tabController,
          tabs: [
            Tabs(icon: Icons.bluetooth_searching),
            Tabs(icon: Icons.bluetooth_connected)
          ],
        ),
        title: Text('Garagedoor openeer'),
      ),
      body: TabBarView(
        controller: this.widget.tabController,
        children: [
          ControlScreen(),
          DevicesScreen(),
        ],
      ),
    );
  }
}
