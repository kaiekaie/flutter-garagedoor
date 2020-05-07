import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';

class EventProvider extends ChangeNotifier {}

class FlutterBlueDevices extends ChangeNotifier {
  BluetoothDevice connectedDevice;
  bool isScanning = false;
  List<ScanResult> scanResults;
  BluetoothCharacteristic characteristic;
  BluetoothService service;
  String error = "";
  bool isOpen = false;
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  FlutterBlueDevices(
      {this.connectedDevice, this.isScanning = false, this.scanResults});

  remove() {
    this.connectedDevice.disconnect();
    this.connectedDevice = null;
    notifyListeners();
  }

  void isOpenOrNot(String isopen) {
    print(isopen);
    this.isOpen = isopen == "true";
    notifyListeners();
  }

  BluetoothDevice _getConnected(List<BluetoothDevice> devices) {
    if (devices.where((e) => e.name == "garagedooropener").isNotEmpty) {
      return devices.where((e) => e.name == "garagedooropener").first;
    }
    return null;
  }

  Future<BluetoothDevice> _startScan() async {
    var asyncDevice = this._flutterBlue.scan(
        timeout: Duration(seconds: 10),
        withServices: [new Guid("fffffffffffffffffffffffffffffff0")]);
    await for (var scanResult in asyncDevice) {
      return scanResult.device;
    }
    return null;
  }

  void listen() {
    if (this.connectedDevice != null) {
      this.connectedDevice.state.listen((BluetoothDeviceState e) {
        if (e.index == 0) {
          this.connectedDevice = null;
          this.isOpen = false;
          this.characteristic = null;
          notifyListeners();
        }
      });
    }
  }

  void subscribeNotify() {
    if (this.characteristic != null) {
      this
          .characteristic
          .value
          .listen((onData) => isOpenOrNot(utf8.decode(onData)));
    }
  }

  setChar(BluetoothCharacteristic char) {
    this.characteristic = char;
  }

  setIsOpen(BluetoothCharacteristic characteristic) async {
    var data = await characteristic.read();

    isOpenOrNot(utf8.decode(data));
  }

  setOpen() async {
    try {
      await this.characteristic.write([0, 0, 0, 0]);
    } catch (e) {
      print(e);
    }
  }

  stopNotify() async {
    await this.characteristic.setNotifyValue(false);
    notifyListeners();
  }

  startNotify() async {
    await this.characteristic.setNotifyValue(true);
    notifyListeners();
  }

  clearError() {
    this.error = "";
    notifyListeners();
  }

  updateIsOpen() async {
    var data = await this.characteristic.read();

    isOpenOrNot(utf8.decode(data));
  }

  getLoginCharacteristic(List<BluetoothCharacteristic> characteristics) {
    return characteristics
        .where((e) => e.uuid == Guid("ffffffff-ffff-ffff-ffff-fffffffffff2"))
        .first;
  }

  getButtonCharacteristic(List<BluetoothCharacteristic> characteristics) {
    return characteristics
        .where((e) => e.uuid == Guid("ffffffff-ffff-ffff-ffff-fffffffffff1"))
        .first;
  }

  setService(Stream<List<BluetoothService>> services) async {
    const String serviceId = 'ffffffff-ffff-ffff-ffff-fffffffffff0';

    services.listen((e) async {
      var service = e.where((e) => e.uuid.toString() == serviceId).first;
      this.characteristic = getButtonCharacteristic(service.characteristics);
      setIsOpen(this.characteristic);
      notifyListeners();
    });
  }

  connectAndDiscover(BluetoothDevice device) async {
    await device.connect();
    await device.discoverServices();
    await setService(device.services);
    this.connectedDevice = device;
    this.isScanning = false;
    notifyListeners();
  }

  connect() async {
    try {
      BluetoothDevice device;
      if (this.connectedDevice == null) {
        var connecteDevices = await this._flutterBlue.connectedDevices;

        this.isScanning = true;
        notifyListeners();
        device = _getConnected(connecteDevices);
        if (device != null) {
          connectAndDiscover(device);
        } else {
          print("kommer vi hit?");
          device = await _startScan();

          if (device != null) {
            connectAndDiscover(device);
          } else {
            this.error = "finner ikke device";
            this.isScanning = false;
            notifyListeners();
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  factory FlutterBlueDevices.fromMap(Map data) {
    return FlutterBlueDevices(
        connectedDevice: data["connectedDevice"] ?? null,
        isScanning: data["isScanning"] ?? false,
        scanResults: data["scanResults"] ?? []);
  }
}

class UtilsData extends ChangeNotifier {
  Map data = {'current': 'control_screen'};
}

// class Stream {
//   final List<BluetoothDevice> devicesList = new List<BluetoothDevice>();
//   final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();
// }

class FlutterBlueData extends ChangeNotifier {}
