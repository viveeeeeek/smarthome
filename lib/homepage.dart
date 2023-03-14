import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smarthome/extras/constants.dart';
import 'package:smarthome/providers/esp8266_provider.dart';
import 'package:smarthome/widgets/esp8266_status_card.dart';
import 'package:smarthome/widgets/ifconnected.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/widgets/popup_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DeviceProvider deviceProvider;
  bool _isSwitched = false;
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
      deviceProvider.checkDeviceConnection();
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
    deviceProvider = Provider.of<DeviceProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => DeviceProvider(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: scaffoldBackground,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                ESP8266StatusCard(
                  deviceProvider: deviceProvider,
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
                        //! Main UI
                        IfConnected(
                          isConnected: deviceProvider.isDeviceConnected,
                          connectedWidget: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    width: 200,
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'LED 1',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 500),
                                            child: Icon(
                                              _isSwitched
                                                  ? Icons.lightbulb
                                                  : Icons.lightbulb_outline,
                                              key: ValueKey<bool>(_isSwitched),
                                              size: 100,
                                              color: _isSwitched
                                                  ? Colors.yellow
                                                  : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          //! Switch on off led
                                          AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 500),
                                            child: Center(
                                              child: Switch(
                                                value: _isSwitched,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _isSwitched = value;
                                                    deviceProvider
                                                        .toggleLED(value);
                                                  });
                                                },
                                              ),
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
                          disconnectedWidget: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22))),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
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
                                  const SizedBox(
                                    height: 22,
                                  ),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
