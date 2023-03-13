import 'package:flutter/material.dart';

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
