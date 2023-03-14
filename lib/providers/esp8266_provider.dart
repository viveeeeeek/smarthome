import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/secrets.dart';

class DeviceProvider with ChangeNotifier {
  bool _isDeviceConnected = false;

  bool get isDeviceConnected => _isDeviceConnected;

  Future<void> checkDeviceConnection() async {
    final url = Uri.parse(isHardwareConnected);
    final response = await http.get(url);

    if (response.body == 'true') {
      print("ESP8266 is connected");
      _isDeviceConnected = true;
    } else {
      print("Connect ESP8266 / Configure wifi");
      _isDeviceConnected = false;
    }
    notifyListeners();
  }

  void toggleLED(bool value) async {
    String endpoint = value ? updateVirtualPin1 : updateVirtualPin0;
    await http.get(Uri.parse(endpoint));
  }
}
