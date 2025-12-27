import 'dart:ui';

import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageType{
  String name;
  Locale locale;

  LanguageType(this.name, this.locale);
}

// 语言列表
List<LanguageType> get supportedLocales => [
  LanguageType("English", Locale("en", "US")),
  LanguageType("简体中文", Locale("zh", "CN")),
  LanguageType("繁體中文", Locale("zh", "TW")),
];


class Controller extends GetxController {
  RxBool running = false.obs;
  RxList<String> log = RxList<String>([]);

  RxList<TaskItem> fileList=RxList<TaskItem>([]);
  RxInt selectIndex=0.obs;
  TextEditingController output=TextEditingController();
  RxString ffmpeg=''.obs;

  RxBool useNotification=true.obs;

  Rx<LanguageType> lang=Rx(supportedLocales[0]);
  late SharedPreferences prefs;

  initPrefs(){
    bool? prefNotification=prefs.getBool('useNotification');
    final prefOutput=prefs.getString('output');
    final prefFFmpeg=prefs.getString('ffmpeg');
    if(prefNotification!=null){
      useNotification.value=prefNotification;
    }
    if(prefOutput!=null){
      output.text=prefOutput;
      output.text=prefOutput;
    }

    if(prefFFmpeg!=null){
      ffmpeg.value=prefFFmpeg;
      return;
    }

    // TODO 如果没有获取到FFmpeg ?
  }

  Future<void> init() async {
    prefs=await SharedPreferences.getInstance();

    initPrefs();

    int? langIndex=prefs.getInt("langIndex");

    if(langIndex==null){
      final deviceLocale=PlatformDispatcher.instance.locale;
      final local=Locale(deviceLocale.languageCode, deviceLocale.countryCode);
      int index=supportedLocales.indexWhere((element) => element.locale==local);
      if(index!=-1){
        lang.value=supportedLocales[index];
        lang.refresh();
      }
    }else{
      lang.value=supportedLocales[langIndex];
    }
  }

  void changeLanguage(int index){
    lang.value=supportedLocales[index];
    prefs.setInt("langIndex", index);
    lang.refresh();
    Get.updateLocale(lang.value.locale);
  }
}