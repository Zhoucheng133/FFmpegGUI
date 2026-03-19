import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showSettings(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('settings'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
          ]
        )
      );
    }
  );
}