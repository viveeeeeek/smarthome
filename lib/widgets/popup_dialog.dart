import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class PopUpDialog extends StatelessWidget {
  const PopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Connect Your ESP8266 Device to Wi-Fi',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Follow these steps to connect your device:'),
            SizedBox(height: 16),
            Text('1. Power on your ESP8266 device.'),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: '2. Connect to the ',
                children: [
                  TextSpan(
                    text: '"smarthome"',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        ' Wi-Fi access point with password "smarthome" in your device\'s Wi-Fi settings.',
                  )
                ],
              ),
            ),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: '3. Click "',
                children: [
                  TextSpan(
                    text: 'smarthome',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '" again to sign in.'),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text:
                    '4. Select your Wi-Fi network from the list of available networks.',
              ),
            ),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: '5. Enter your Wi-Fi password and click "',
                children: [
                  TextSpan(
                    text: 'Connect',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '".'),
                ],
              ),
            ),
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
  }
}
