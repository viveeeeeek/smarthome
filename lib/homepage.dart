import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_settings/app_settings.dart';
import 'package:smarthome/api/secrets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isSwitched = false;
  bool _isDeviceConnected = false;
  late Timer _timer;
  //! Init method where it starts timer
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  //! Start timer method where it waits for 5 seconds and then checks for DeviceConnection
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkDeviceConnection();
    });
  }

  //! To stop timer
  void _stopTimer() {
    _timer?.cancel();
  }

  //! Dispose method
  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  //! To chheck device connection if it is connected or not
  Future<void> _checkDeviceConnection() async {
    final url = Uri.parse(isHardwareConnected);
    final response = await http.get(url);

    if (response.body == 'true') {
      print("ESP8266 is connected");
      setState(() {
        _isDeviceConnected = true;
      });
    } else {
      print("Connect ESP8266 / Configure wifi");
      setState(() {
        _isDeviceConnected = false;
      });
    }
  }

  //! COnfigure wifi
  void _configureWifi() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Configure Wi-Fi'),
          content: const Text(
              'Please configure your Wi-Fi settings to connect your device to the internet.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Implement your Wi-Fi configuration logic here.
                Navigator.pop(context);
                AppSettings.openWIFISettings();
              },
              child: Text('Configure'),
            ),
          ],
        );
      },
    );
  }

  //! Handle Toggle LED
  void _toggleLED(bool value) async {
    String endpoint = value ? updateVirtualPin1 : updateVirtualPin0;
    await http.get(Uri.parse(endpoint));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //! Device connection status
            Center(
              child: _isDeviceConnected
                  ? Text('Device is connected to the internet.')
                  : ElevatedButton(
                      onPressed: _configureWifi,
                      child: Text('Configure Wi-Fi'),
                    ),
            ),
            const SizedBox(
              height: 50,
            ),
            _isDeviceConnected == true
                ? Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Icon(
                              _isSwitched == true
                                  ? Icons.lightbulb
                                  : Icons.lightbulb_outline,
                              size: 100,
                              color: _isSwitched == true
                                  ? Colors.yellow
                                  : Colors.black,
                            ),
                            Expanded(child: SizedBox()),
                            //! Switch on off led
                            Center(
                              child: Switch(
                                value: _isSwitched,
                                onChanged: (value) {
                                  setState(() {
                                    _isSwitched = value;
                                    _toggleLED(value);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
