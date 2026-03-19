import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConfigChannel extends StatefulWidget {
  const ConfigChannel({super.key});

  @override
  State<ConfigChannel> createState() => _ConfigChannelState();
}

class _ConfigChannelState extends State<ConfigChannel> {

  final Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        children: [
          SizedBox(
            width: 90,
            child: Text('channel'.tr),
          ),
          Padding(
            padding: .only(left: 5),
            child: SizedBox(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: controller.fileList[controller.selectIndex.value].channel.toString()),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  contentPadding: .symmetric(vertical: 10, horizontal: 5),
                ),
                onChanged: (val){
                  try{
                    controller.fileList[controller.selectIndex.value].channel=int.parse(val);
                  }catch(_){}
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}