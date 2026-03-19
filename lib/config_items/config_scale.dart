import 'package:ffmpeg_gui/components/dropdown.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ConfigScale extends StatefulWidget {
  const ConfigScale({super.key});

  @override
  State<ConfigScale> createState() => _ConfigScaleState();
}

List<String> scaleItems=[
  'noScale'.tr,
  '1080p',
  '720p',
  'custom'.tr
];

class _ConfigScaleState extends State<ConfigScale> {

  final Controller controller=Get.find();

  TextEditingController widthController = TextEditingController(text: "1920");
  TextEditingController heightController = TextEditingController(text: "1080");

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Row(
          crossAxisAlignment: .center, 
          children: [
            SizedBox(
              width: 90,
              child: Text('scale'.tr),
            ),
            Dropdown(
              value: controller.selectedTask.sizeSelected(), 
              onChanged: (val){
                if(val=='noScale'.tr){
                  controller.fileList[controller.selectIndex.value].customSize=false;
                  controller.fileList[controller.selectIndex.value].width=null;
                  controller.fileList[controller.selectIndex.value].height=null;
                }else if(val=='custom'.tr){
                  controller.fileList[controller.selectIndex.value].customSize=true;
                  widthController.text="1920";
                  heightController.text="1080";
                }else{
                  controller.fileList[controller.selectIndex.value].customSize=false;
                  if(val=='1080p'){
                    controller.fileList[controller.selectIndex.value].width=1920;
                    controller.fileList[controller.selectIndex.value].height=1080;
                  }else if(val=='720p'){
                    controller.fileList[controller.selectIndex.value].width=1280;
                    controller.fileList[controller.selectIndex.value].height=720;
                  }
                }
                controller.fileList.refresh();
              },
              items: scaleItems.map((val)=>DropdownListItem(
                label: val, 
                value: val
              )).toList()
            )
          ],
        ),
        if(controller.fileList[controller.selectIndex.value].customSize==true) Padding(
          padding: .only(top: 10, left: 95),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: widthController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: .symmetric(vertical: 10, horizontal: 5)
                  ),
                  onChanged: (val){
                    try{
                      controller.fileList[controller.selectIndex.value].width=int.parse(val);
                    }catch(_){}
                  },
                ),
              ),
              Padding(
                padding: .symmetric(horizontal: 10),
                child: FaIcon(
                  FontAwesomeIcons.xmark,
                  size: 20,
                )
              ),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: heightController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: .symmetric(vertical: 10, horizontal: 5)
                  ),
                  onChanged: (val){
                    try{
                      controller.fileList[controller.selectIndex.value].height=int.parse(val);
                    }catch(_){}
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}