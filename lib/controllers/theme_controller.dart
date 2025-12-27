import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool darkMode=false.obs;
  RxBool autoDark=true.obs;

  Color bgColor(BuildContext context){
    return Theme.of(context).colorScheme.surface;
  }

  Color buttonColor(BuildContext context, bool hover, bool selected){
    if(!darkMode.value){
      return selected ? Theme.of(context).colorScheme.primary.withAlpha(18) : hover ? Theme.of(context).colorScheme.primary.withAlpha(12) : Theme.of(context).colorScheme.primary.withAlpha(0);
    }else{
      return selected ? Color.fromARGB(255, 60, 60, 60) : hover ? Color.fromARGB(255, 40, 40, 40) : Theme.of(context).colorScheme.surface;
    }
  }

  void darkModeHandler(bool dark){
    if(autoDark.value){
      darkMode.value=dark;
    }
  }
}