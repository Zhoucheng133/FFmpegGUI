import 'package:ffmpeg_gui/components/dropdown.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigOutput extends StatefulWidget {
  const ConfigOutput({super.key});

  @override
  State<ConfigOutput> createState() => _ConfigOutputState();
}

class _ConfigOutputState extends State<ConfigOutput> {

  final Controller controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        children: [
          SizedBox(
            width: 90,
            child: Text('outputStyle'.tr),
          ),
          Dropdown(
            value: controller.selectedTask.outType, 
            onChanged: (value){
              value=value as Types?;
              if(value!=null){
                controller.fileList[controller.selectIndex.value].outType=value;
                if(controller.fileList[controller.selectIndex.value].outType==Types.video){
                  controller.fileList[controller.selectIndex.value].format=Formats.mp4;
                  controller.fileList[controller.selectIndex.value].videoEncoders=VideoEncoders.libx264;
                  controller.fileList[controller.selectIndex.value].audioEncoders=AudioEncoders.aac;
                }else if(controller.fileList[controller.selectIndex.value].outType==Types.audio){
                  controller.fileList[controller.selectIndex.value].format=Formats.mp3;
                  controller.fileList[controller.selectIndex.value].audioEncoders=AudioEncoders.libmp3lame;
                }
                controller.fileList.refresh();
              }
            },
            items: [
              if(controller.fileList[controller.selectIndex.value].type!=Types.audio) DropdownListItem(label: 'video'.tr, value: Types.video),
              DropdownListItem(label: 'audio'.tr, value: Types.audio)
            ]
          )
        ],
      ),
    );
  }
}