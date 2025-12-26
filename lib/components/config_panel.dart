import 'package:flutter/material.dart';

class ConfigPanel extends StatefulWidget {
  const ConfigPanel({super.key});

  @override
  State<ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends State<ConfigPanel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 15, top: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness==Brightness.dark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
            ],
          )
        ),
      ),
    );
  }
}