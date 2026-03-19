import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigClip extends StatefulWidget {
  const ConfigClip({super.key});

  @override
  State<ConfigClip> createState() => _ConfigClipState();
}

class _ConfigClipState extends State<ConfigClip> {

  final controller=Get.find<Controller>();
  TextEditingController startController=TextEditingController(text: "00:00:00");
  TextEditingController endController=TextEditingController(text: "00:00:10");

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Column(
        mainAxisSize: .min,
        children: [
          Row(
            crossAxisAlignment: .center, 
            children: [
              SizedBox(
                width: 90,
                child: Text('clip'.tr),
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      mouseCursor: SystemMouseCursors.basic,
                      value: controller.selectedTask.enableClip,
                      splashRadius: 0,
                      onChanged: (val){
                        controller.fileList[controller.selectIndex.value].enableClip=val;
                        controller.fileList.refresh();
                      }
                    ),
                  ),
                  Text("useClip".tr)
                ],
              ),
            ],
          ),
          if(controller.fileList[controller.selectIndex.value].enableClip) const SizedBox(height: 10,),
          if(controller.fileList[controller.selectIndex.value].enableClip) Padding(
            padding: .only(left: 95),
            child: Row(
              mainAxisAlignment: .start,
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    enabled: controller.selectedTask.enableClip,
                    controller: startController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      contentPadding: .symmetric(vertical: 10, horizontal: 5)
                    ),
                    onChanged: (String value){
                      controller.fileList[controller.selectIndex.value].clipStart=value;
                    },
                  ),
                ),
                Padding(
                  padding: .symmetric(horizontal: 10),
                  child: Text(
                    "~",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    enabled: controller.selectedTask.enableClip,
                    controller: endController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      contentPadding: .symmetric(vertical: 10, horizontal: 5)
                    ),
                    onChanged: (String value){
                      controller.fileList[controller.selectIndex.value].clipEnd=value;
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}