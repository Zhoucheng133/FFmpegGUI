import 'package:ffmpeg_gui/components/dropdown.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ConfigSubtitle extends StatefulWidget {
  const ConfigSubtitle({super.key});

  @override
  State<ConfigSubtitle> createState() => _ConfigSubtitleState();
}

class _ConfigSubtitleState extends State<ConfigSubtitle> {

  final Controller controller=Get.find();

  String subtitleToString(SubTitleType type){
    switch (type) {
      case SubTitleType.none:
        return 'none'.tr;
      case SubTitleType.embed:
        return 'embed'.tr;
      case SubTitleType.file:
        return 'external'.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        children: [
          SizedBox(
            width: 90,
            child: Text('track'.tr),
          ),
          Dropdown(
            value: controller.selectedTask.subTitleType, 
            onChanged: (val) async {
              val = val as SubTitleType?;
              if(val!=null){
                if(val==SubTitleType.embed){
                  controller.fileList[controller.selectIndex.value].subtitleTrack=0;
                }else if(val==SubTitleType.file){
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    allowedExtensions: ['srt', 'ass', 'vtt'],
                    type: FileType.custom,
                    allowMultiple: false,
                  );
                  if(result != null){
                    controller.fileList[controller.selectIndex.value].subTitleFile=result.files.single.path!;
                  }else{
                    return;
                  }
                }
                controller.fileList[controller.selectIndex.value].subTitleType=val;
                controller.fileList.refresh();
              }
            }, 
            items: SubTitleType.values.map((e) => DropdownListItem(
              value: e,
              label: subtitleToString(e),
            )).toList(),
          ),
          if(controller.selectedTask.subTitleType==SubTitleType.embed) Padding(
            padding: .only(left: 10),
            child: SizedBox(
              width: 100,
              child: TextField(
                controller: TextEditingController(text: controller.fileList[controller.selectIndex.value].subtitleTrack.toString()),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  contentPadding: .symmetric(vertical: 12, horizontal: 5),
                  labelText: "subtitleTrack".tr
                ),
                onChanged: (val){
                  try{
                    controller.fileList[controller.selectIndex.value].subtitleTrack=int.parse(val);
                  }catch(_){}
                },
              ),
            )
          ),
          if(controller.selectedTask.subTitleType==SubTitleType.file) Expanded(
            child: Padding(
              padding: .only(left: 10),
              child: Expanded(
                child: Text(
                  controller.fileList[controller.selectIndex.value].subTitleFile.split('/').last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              )
            ),
          )
        ],
      ),
    );
  }
}