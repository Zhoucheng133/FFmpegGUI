import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showSettings(BuildContext context) async {

  final Controller controller=Get.find();
  final prefs=await SharedPreferences.getInstance();

  await showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('settings'.tr),
        content: Obx(
          ()=> Column(
            crossAxisAlignment: .start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      'useNotification'.tr
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      mouseCursor: SystemMouseCursors.basic,
                      value: controller.useNotification.value, 
                      onChanged: (val){
                        controller.useNotification.value=val;
                        prefs.setBool("useNotification", val);
                      }
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      'ffmpegPath'.tr
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        isCollapsed: true,
                        contentPadding: .symmetric(vertical: 10, horizontal: 5),
                      ),
                      controller: TextEditingController(text: controller.ffmpeg.value),
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding: .only(left: 5),
                    child: FilledButton(
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          controller.setFFmpegPath(result.files.single.path!);
                        }
                      }, 
                      child: Text('select'.tr)
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row( 
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      'language'.tr
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      focusColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      value: controller.lang.value.name,
                      items: supportedLocales.map((item)=>DropdownMenuItem<String>(
                        value: item.name,
                        child: Text(
                          item.name
                        ),
                      )).toList(),
                      onChanged: (val){
                        final index=supportedLocales.indexWhere((element) => element.name==val);
                        controller.changeLanguage(index);
                      },
                    ),
                  )
                ],
              ),
            ]
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('ok'.tr)
          )
        ],
      );
    }
  );
}