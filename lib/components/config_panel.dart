import 'dart:io';

import 'package:ffmpeg_gui/components/dropdown.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/service/codec_handler.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class ConfigPanel extends StatefulWidget {
  const ConfigPanel({super.key});

  @override
  State<ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends State<ConfigPanel> {

  final Controller controller=Get.find();

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
          child: Obx(
            () => controller.fileList.isEmpty ? Container() : ListView(
              children: [
                Text(
                  p.basename(controller.selectedTask.path),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text('fullPath'.tr),
                    ),
                    Expanded(
                      child: Text(
                        controller.selectedTask.path,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text('outputStyle'.tr),
                    ),
                    Dropdown(
                      value: controller.selectedTask.outType, 
                      onChanged: (value){
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
                        DropdownListItem(label: 'video'.tr, value: Types.video),
                        DropdownListItem(label: 'audio'.tr, value: Types.audio)
                      ]
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
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
                            value=value as VideoEncoders;
                            controller.fileList[controller.selectIndex.value].videoEncoders=value;
                            controller.fileList.refresh();
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
                            value=value as AudioEncoders;
                            controller.fileList[controller.selectIndex.value].audioEncoders=value;
                            controller.fileList.refresh();
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
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text('format'.tr),
                    ),
                    // DropdownButtonHideUnderline(
                    //   child: DropdownButton2(
                    //     items: [
                    //       DropdownMenuItem(child: child)
                    //     ]
                    //   )
                    // )
                  ]
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}