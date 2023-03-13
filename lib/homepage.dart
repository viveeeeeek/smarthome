import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:smarthome/api/secrets.dart';
import 'package:smarthome/extras/constants.dart';
import 'package:smarthome/widgets/ifconnected.dart';
import 'package:smarthome/widgets/popUpDialog.dart';

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
        return const PopUpDialog();
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
                              height: 250,
                              width: screenSize.width,
                              child: Center(
                                child: Lottie.asset(
                                  "assets/connection_lost.json",
                                  height: 250,
                                  width: 250,
                                ),
                              ),
                            ),
                            const Text(
                              "To get started, please make sure that:",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "1. Your ESP8266 device is connected properly.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "2. Your ESP8266 device is configured to connect to your Wi-Fi network.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: SizedBox(
                                width: screenSize.width / 1.5,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: _configureWifi,
                                  child: const Text('Configure Wi-Fi'),
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
