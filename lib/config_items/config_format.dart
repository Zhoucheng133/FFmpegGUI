import 'package:ffmpeg_gui/components/dropdown.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigFormat extends StatefulWidget {
  const ConfigFormat({super.key});

  @override
  State<ConfigFormat> createState() => _ConfigFormatState();
}

class _ConfigFormatState extends State<ConfigFormat> {

  final controller=Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text('format'.tr),
          ),
          Dropdown(
            value: controller.selectedTask.format, 
            onChanged: (value){
              value=value as Formats?;
              if(value!=null){
                controller.fileList[controller.selectIndex.value].format=value;
                controller.fileList.refresh();
              }
            }, 
            items: Formats.values.map((item)=>DropdownListItem(
              value: item,
              label: item.name
            )).toList(),
          )
        ]
      ),
    );
  }
}