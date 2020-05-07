import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String device;

  Settings({this.device});

  setDevice(String device) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString("device", device);
    this.device = device;
    notifyListeners();
  }

  getDevice() async {
    final SharedPreferences prefs = await _prefs;
    this.device = prefs.getString("device");
    notifyListeners();
  }

  factory Settings.fromMap(Map data) {
    return Settings(device: data["device"] ?? "");
  }
}
