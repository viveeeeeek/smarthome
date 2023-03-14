import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smarthome/widgets/ifconnected.dart';
import '../providers/esp8266_provider.dart';

class ESP8266StatusCard extends StatefulWidget {
  const ESP8266StatusCard({super.key, required this.deviceProvider});

  final DeviceProvider deviceProvider;

  @override
  State<ESP8266StatusCard> createState() => _ESP8266StatusCardState();
}

class _ESP8266StatusCardState extends State<ESP8266StatusCard> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider<DeviceProvider>.value(
      value: widget.deviceProvider,
      child:
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
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  //! ESP8266 Device image goes here
                  child: Image.asset(
                    'assets/microcontroller.jpg',
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
                        isConnected: widget.deviceProvider.isDeviceConnected,
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
                        isConnected: widget.deviceProvider.isDeviceConnected,
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
    );
  }
}
