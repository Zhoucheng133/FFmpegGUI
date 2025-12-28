import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/dialogs/dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showPickFFmpegDialog(BuildContext context){
  TextEditingController controller=TextEditingController();
  showDialog(
    context: context, 
    barrierDismissible: false, 
    builder: (context)=>AlertDialog(
      title: Text("ffmpegPath".tr),
      content: SizedBox(
        width: 350,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enabled: false,
                controller: controller,
                style: TextStyle(
                  fontSize: 15
                ),
                decoration: InputDecoration(
                  hintText: "pickFFmpeg".tr,
                  border: OutlineInputBorder(),
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
                ),
              )
            ),
            const SizedBox(width: 10,),
            FilledButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  controller.text=result.files.single.path!;
                }
              }, 
              child: Text('select'.tr)
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            if(controller.text.isEmpty || !controller.text.endsWith("ffmpeg")){
              okDialog(context, "setFailed".tr, "pathInvalid".tr);
            }else{
              Get.find<Controller>().setFFmpegPath(controller.text);
              Navigator.pop(context);
            }
          }, 
          child: Text('ok'.tr)
        )
      ],
    )
  );
}