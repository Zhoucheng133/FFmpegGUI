import 'dart:io';

import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/dialogs/dialogs.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TaskAdder {

  final Controller controller=Get.find();

  bool judgeFile(String path){
    if(path.endsWith('.mp4') || path.endsWith('.mkv') || path.endsWith('.flv') || path.endsWith('.mov')){
      return true;
    }else if(path.endsWith('.mp3') || path.endsWith('acc') || path.endsWith('flac') || path.endsWith('wav')){
      return true;
    }
    return false;
  }

  void pickFile() async {
    if(controller.running.value){
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'mkv', 'flv', 'mov', 'acc', 'flac', 'wav']
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for (var element in files) {
        controller.fileList.add(TaskItem(path: element.path));
      }
    }
  }

  void pickDir() async {
    if(controller.running.value){
      return;
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if(selectedDirectory!=null){
      final directory = Directory(selectedDirectory);
      List<FileSystemEntity> allFiles = directory.listSync();
      List<String> files = allFiles.where((file) {
        return file is File && judgeFile(file.path);
      }).map((file)=>file.path).toList();
      files.sort();
      for(var path in files){
        controller.fileList.add(TaskItem(path: path));
      }
    }
  }

  void pickUrl(BuildContext context) async {

    final TextEditingController urlController = TextEditingController();

    if(controller.running.value){
      return;
    }
    final rlt=await customOkCancelDialog(
      context, 
      'fromUrl'.tr, 
      SizedBox(
        width: 350,
        child: TextField(
          controller: urlController,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'http(s)://',
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10)
          ),
          maxLines: 4,
        ),
      ),
      okText: 'add'.tr
    );

    if(rlt==true){
      if(urlController.text.isEmpty){
        okDialog(context, "addFail".tr, "urlEmpty".tr);
        return;
      }else if(!urlController.text.startsWith('http://') && !urlController.text.startsWith('https://')){
        okDialog(context, "addFail".tr, "urlInvalid".tr);
        return;
      }
      controller.fileList.add(TaskItem(path: urlController.text));
    }

    urlController.dispose();
  }

  Future<void> showAddMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    ).shift(const Offset(0, 32));
    final key=await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'file',
          height: 40, 
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: FaIcon(FontAwesomeIcons.file, size: 15,)
              ),
              Text("fromFile".tr),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'dir',
          height: 40, 
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: FaIcon(FontAwesomeIcons.folder, size: 15,)
              ),
              Text("fromDir".tr),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'network',
          height: 40, 
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: FaIcon(FontAwesomeIcons.link, size: 13,)
              ),
              Text("fromUrl".tr),
            ],
          ),
        ),
      ],
    );

    if(key=='file'){
      pickFile();
    }else if(key=='dir'){
      pickDir();
    }else if(key=='network'){
      pickUrl(context);
    }
  }
}