import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConfigTrack extends StatefulWidget {
  const ConfigTrack({super.key});

  @override
  State<ConfigTrack> createState() => _ConfigTrackState();
}

class _ConfigTrackState extends State<ConfigTrack> {

  final controller=Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        children: [
          SizedBox(
            width: 90,
            child: Text('track'.tr),
          ),
          Padding(
            padding: .only(left: 5),
            child: SizedBox(
              width: 100,
              child: TextField(
                enabled: controller.selectedTask.videoEncoders!=VideoEncoders.copy,
                controller: TextEditingController(text: controller.fileList[controller.selectIndex.value].videoTrack.toString()),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  contentPadding: .symmetric(vertical: 12, horizontal: 5),
                  labelText: "videoTrack".tr
                ),
                onChanged: (val){
                  try{
                    controller.fileList[controller.selectIndex.value].videoTrack=int.parse(val);
                  }catch(_){}
                },
              ),
            ),
          ),
          Padding(
            padding: .only(left: 10),
            child: SizedBox(
              width: 100,
              child: TextField(
                enabled: controller.selectedTask.audioEncoders!=AudioEncoders.copy,
                controller: TextEditingController(text: controller.fileList[controller.selectIndex.value].audioTrack.toString()),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  contentPadding: .symmetric(vertical: 12, horizontal: 5),
                  labelText: "audioTrack".tr
                ),
                onChanged: (val){
                  try {
                    controller.fileList[controller.selectIndex.value].audioTrack=int.parse(val);
                  } catch (_) {}
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}