import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_settings/app_settings.dart';
import 'package:lottie/lottie.dart';
import 'package:smarthome/api/secrets.dart';
import 'package:smarthome/extras/constants.dart';

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
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _checkDeviceConnection();
    });
  }

  //! To stop timer
  void _stopTimer() {
    _timer.cancel();
  }

  //! Dispose method
  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  //! To check device connection if it is connected or not
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

  //! Handle Toggle LED
  void _toggleLED(bool value) async {
    String endpoint = value ? updateVirtualPin1 : updateVirtualPin0;
    await http.get(Uri.parse(endpoint));
  }

  //! Configure wifi
  void _configureWifi() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connect Your ESP8266 Device to Wi-Fi'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Follow these steps to connect your device:'),
                SizedBox(height: 16),
                Text('1. Power on your ESP8266 device.'),
                SizedBox(height: 8),
                Text(
                    '2. Go to your Wi-Fi settings and connect to the SmartHome access point.'),
                SizedBox(height: 8),
                Text(
                    '3. Once connected, open a web browser and navigate to 192.168.4.1'),
                SizedBox(height: 8),
                Text(
                    '4. Select your Wi-Fi network from the list of available networks.'),
                SizedBox(height: 8),
                Text('5. Enter your Wi-Fi password and click Connect.'),
                SizedBox(height: 16),
                Text(
                    'Note: Your ESP8266 device will automatically restart after it connects to your Wi-Fi network.'),
                SizedBox(height: 16),
                Text(
                    'If you need additional help, please refer to the user manual.'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                AppSettings.openWIFISettings();
              },
              child: const Text('Open Wi-Fi Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldBackground,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              //! Device Container / ESP8266 Status Card
              Container(
                height: 150,
                width: screenSize.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        height: 125,
                        width: 125,
                        decoration: const BoxDecoration(
                            color: Colors.lightGreenAccent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          //! ESP8266 Device image goes here
                          child: Image.asset(
                            'assets/jaiyaxh_pfp.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "ESP8266",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              IfConnected(
                                isConnected: _isDeviceConnected,
                                connectedWidget: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: Lottie.asset(
                                      "assets/online_status.json",
                                    )),
                                disconnectedWidget: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Lottie.asset(
                                      "assets/loading.json",
                                    )),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Device status :",
                                style: TextStyle(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IfConnected(
                                isConnected: _isDeviceConnected,
                                connectedWidget: const Text("Connected"),
                                disconnectedWidget: const Text(
                                  "Disconnected",
                                  style: TextStyle(),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                  child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IfConnected(
                        isConnected: _isDeviceConnected,
                        connectedWidget: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
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
                                        const Expanded(child: SizedBox()),
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
                              ),
                            ],
                          ),
                        ),
                        //! Connection lost / Configure ESP help
                        disconnectedWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 400,
                              width: screenSize.width,
                              child: Center(
                                child: Lottie.asset(
                                    "assets/connection_lost.json",
                                    height: 250,
                                    width: 250),
                              ),
                            ),
                            const Text(
                              "Please make sure",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "1) ESP8266 is connected properly.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "2) Wifi is configured for ESP8266.",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            //! Configure wifi button
                            Center(
                              child: SizedBox(
                                width: screenSize.width / 1.5,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: _configureWifi,
                                  child: Text('Configure Wi-Fi'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

//! IF Connected then connectedWidget else disconnectedWidget
class IfConnected extends StatelessWidget {
  const IfConnected({
    Key? key,
    required this.isConnected,
    required this.connectedWidget,
    required this.disconnectedWidget,
  }) : super(key: key);

  final bool isConnected;
  final Widget connectedWidget;
  final Widget disconnectedWidget;

  @override
  Widget build(BuildContext context) {
    return isConnected ? connectedWidget : disconnectedWidget;
  }
}
