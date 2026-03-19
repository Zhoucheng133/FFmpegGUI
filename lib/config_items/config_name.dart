import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigName extends StatefulWidget {
  const ConfigName({super.key});

  @override
  State<ConfigName> createState() => _ConfigNameState();
}

class _ConfigNameState extends State<ConfigName> {

  final controller=Get.find<Controller>();
  
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        children: [
          SizedBox(
            width: 90,
            child: Text('rename'.tr),
          ),
          Padding(
            padding: .only(left: 5),
            child: SizedBox(
              width: 350,
              child: TextField(
                controller: TextEditingController(text: controller.fileList[controller.selectIndex.value].outputName),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  contentPadding: .symmetric(vertical: 10, horizontal: 5),
                ),
                onChanged: (val){
                  try{
                    controller.fileList[controller.selectIndex.value].outputName=val;
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