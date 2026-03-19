import 'dart:io';

import 'package:ffmpeg_gui/components/dropdown.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/service/codec_handler.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigCodec extends StatefulWidget {
  const ConfigCodec({super.key});

  @override
  State<ConfigCodec> createState() => _ConfigCodecState();
}

class _ConfigCodecState extends State<ConfigCodec> {

  final Controller controller=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 90,
            child: Text('codec'.tr),
          ),
          Row(
            children: [
              if(controller.selectedTask.outType==Types.video) Dropdown(
                value: controller.selectedTask.videoEncoders, 
                onChanged: (value){
                  value=value as VideoEncoders?;
                  if(value!=null){
                    controller.fileList[controller.selectIndex.value].videoEncoders=value;
                    controller.fileList.refresh();
                  }
                },
                items: VideoEncoders.values
                  .where((item){
                    final excludedEncoders = Platform.isMacOS
                    ? [VideoEncoders.h264nvenc, VideoEncoders.hevcnvenc, VideoEncoders.h264amf, VideoEncoders.hevcamf]
                    : [VideoEncoders.h264videotoolbox, VideoEncoders.hevcvideotoolbox];
                    return !excludedEncoders.contains(item);
                  })
                  .map((item)=>DropdownListItem(
                    value: item,
                    label: videoEncoderToString(item)
                  )).toList(),
              ),
              if(controller.selectedTask.outType==Types.video) const SizedBox(width: 10,),
              Dropdown(
                value: controller.selectedTask.audioEncoders, 
                onChanged: (value){
                  value=value as AudioEncoders?;
                  if(value!=null){
                    controller.fileList[controller.selectIndex.value].audioEncoders=value;
                    controller.fileList.refresh();
                  }
                },
                items:  AudioEncoders.values.map((item)=>DropdownListItem(
                  value: item,
                  label: audioEncoderToString(item)
                )).toList(),
              )
            ],
          ),
        ],
      ),
    );
  }
}