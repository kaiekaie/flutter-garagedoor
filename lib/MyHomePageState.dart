// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';

// import 'main.dart';

// class _MyHomePageState extends State<MyHomePage> {
//   final _writeController = TextEditingController();
//   BluetoothDevice _connectedDevice;
//   List<BluetoothService> _services;
//   final FlutterBlue flutterBlue = FlutterBlue.instance;
//   final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
//   final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

//   _addDeviceTolist(final BluetoothDevice device) {
//     if (!widget.devicesList.contains(device)) {
//       setState(() {
//         widget.devicesList.add(device);
//       });
//     }
//   }

//   void openPage(BuildContext context) {
//     Navigator.push(context, MaterialPageRoute(
//       builder: (BuildContext context) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Next page'),
//           ),
//           body: _buildConnectDeviceView(),
//         );
//       },
//     ));
//   }

//   @override
//   void initState() {
//     super.initState();
//     widget.flutterBlue.connectedDevices
//         .asStream()
//         .listen((List<BluetoothDevice> devices) {
//       for (BluetoothDevice device in devices) {
//         print(device.name);
//         _addDeviceTolist(device);
//       }
//     });
//     widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
//       for (ScanResult result in results) {
//         _addDeviceTolist(result.device);
//       }
//     });
//     widget.flutterBlue.startScan();
//   }

//   ListView _buildListViewOfDevices() {
//     List<Container> containers = new List<Container>();
//     for (BluetoothDevice device in widget.devicesList) {
//       containers.add(
//         Container(
//           height: 50,
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 child: Column(
//                   children: <Widget>[
//                     Text(device.name == '' ? '(unknown device)' : device.name),
//                     Text(device.id.toString()),
//                   ],
//                 ),
//               ),
//               FlatButton(
//                 color: Colors.blue,
//                 child: Text(
//                   'Connect',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () async {
//                   widget.flutterBlue.stopScan();
//                   try {
//                     await device.connect();
//                   } catch (e) {
//                     if (e.code != 'already_connected') {
//                       throw e;
//                     }
//                   } finally {
//                     _services = await device.discoverServices();
//                   }
//                   setState(() {
//                     _connectedDevice = device;
//                   });
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         ...containers,
//       ],
//     );
//   }

//   List<ButtonTheme> _buildReadWriteNotifyButton(
//       BluetoothCharacteristic characteristic) {
//     List<ButtonTheme> buttons = new List<ButtonTheme>();

//     if (characteristic.properties.read) {
//       buttons.add(
//         ButtonTheme(
//           minWidth: 10,
//           height: 20,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: RaisedButton(
//               color: Colors.blue,
//               child: Text('READ', style: TextStyle(color: Colors.white)),
//               onPressed: () async {
//                 var sub = characteristic.value.listen((value) {
//                   setState(() {
//                     widget.readValues[characteristic.uuid] = value;
//                   });
//                 });
//                 await characteristic.read();
//                 sub.cancel();
//               },
//             ),
//           ),
//         ),
//       );
//     }
//     if (characteristic.properties.write) {
//       buttons.add(
//         ButtonTheme(
//           minWidth: 10,
//           height: 20,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: RaisedButton(
//               child: Text('WRITE', style: TextStyle(color: Colors.white)),
//               onPressed: () async {
//                 await showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text("Write"),
//                         content: Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: TextField(
//                                 controller: _writeController,
//                               ),
//                             ),
//                           ],
//                         ),
//                         actions: <Widget>[
//                           FlatButton(
//                             child: Text("Send"),
//                             onPressed: () {
//                               characteristic.write(
//                                   utf8.encode(_writeController.value.text));
//                               Navigator.pop(context);
//                             },
//                           ),
//                           FlatButton(
//                             child: Text("Cancel"),
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ],
//                       );
//                     });
//               },
//             ),
//           ),
//         ),
//       );
//     }
//     if (characteristic.properties.notify) {
//       buttons.add(
//         ButtonTheme(
//           minWidth: 10,
//           height: 20,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: RaisedButton(
//               child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
//               onPressed: () async {
//                 characteristic.value.listen((value) {
//                   widget.readValues[characteristic.uuid] = value;
//                 });
//                 await characteristic.setNotifyValue(true);
//               },
//             ),
//           ),
//         ),
//       );
//     }

//     return buttons;
//   }

//   Future<void> _neverSatisfied() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Rewind and remember'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('You will never be satisfied.'),
//                 Text('You\’re like me. I’m never satisfied.'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('Regret'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   ListView _buildConnectDeviceView() {
//     List<Container> containers = new List<Container>();

//     for (BluetoothService service in _services) {
//       List<Widget> characteristicsWidget = new List<Widget>();

//       for (BluetoothCharacteristic characteristic in service.characteristics) {
//         characteristicsWidget.add(
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Column(
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Text(characteristic.uuid.toString(),
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     ..._buildReadWriteNotifyButton(characteristic),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Text('Value: ' +
//                         widget.readValues[characteristic.uuid].toString()),
//                   ],
//                 ),
//                 Divider(),
//               ],
//             ),
//           ),
//         );
//       }
//       containers.add(
//         Container(
//           child: ExpansionTile(
//               title: Text(service.uuid.toString()),
//               children: characteristicsWidget),
//         ),
//       );
//     }

//     return ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         ...containers,
//       ],
//     );
//   }

//   // ListView _buildView() {
//   //   if (_connectedDevice != null) {
//   //     return _buildConnectDeviceView();
//   //   }
//   //   return _buildListViewOfDevices();
//   // }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(title: Text(widget.title), actions: <Widget>[
//           IconButton(
//               icon: const Icon(Icons.navigate_next),
//               tooltip: 'Next page',
//               onPressed: () {
//                 if (_connectedDevice == null) {
//                   _neverSatisfied();
//                 } else {
//                   openPage(context);
//                 }
//               })
//         ]),
//         body: _buildListViewOfDevices(),
//       );
// }
