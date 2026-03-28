import 'package:ffmpeg_gui/config_items/config_channel.dart';
import 'package:ffmpeg_gui/config_items/config_clip.dart';
import 'package:ffmpeg_gui/config_items/config_codec.dart';
import 'package:ffmpeg_gui/config_items/config_format.dart';
import 'package:ffmpeg_gui/config_items/config_header.dart';
import 'package:ffmpeg_gui/config_items/config_name.dart';
import 'package:ffmpeg_gui/config_items/config_output.dart';
import 'package:ffmpeg_gui/config_items/config_scale.dart';
import 'package:ffmpeg_gui/config_items/config_subtitle.dart';
import 'package:ffmpeg_gui/config_items/config_track.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                ConfigHeader(),
                const SizedBox(height: 10,),
                ConfigOutput(),
                const SizedBox(height: 10,),
                ConfigCodec(),
                const SizedBox(height: 10,),
                ConfigFormat(),
                const SizedBox(height: 10,),
                ConfigClip(),
                if(controller.fileList[controller.selectIndex.value].outType!=Types.audio) const SizedBox(height: 10,),
                if(controller.fileList[controller.selectIndex.value].outType!=Types.audio) ConfigScale(),
                const SizedBox(height: 10,),
                ConfigTrack(),
                const SizedBox(height: 10,),
                ConfigChannel(),
                if(controller.fileList[controller.selectIndex.value].outType!=Types.audio) const SizedBox(height: 10,),
                if(controller.fileList[controller.selectIndex.value].outType!=Types.audio) ConfigSubtitle(),
                const SizedBox(height: 10,),
                ConfigName(),
              ],
            ),
          )
        ),
      ),
    );
  }
}