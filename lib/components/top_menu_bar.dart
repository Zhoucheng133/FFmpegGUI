import 'dart:io';

import 'package:ffmpeg_gui/components/top_menu_bar_item.dart';
import 'package:ffmpeg_gui/service/task.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopMenuBar extends StatefulWidget {
  const TopMenuBar({super.key});

  @override
  State<TopMenuBar> createState() => _TopMenuBarState();
}

class _TopMenuBarState extends State<TopMenuBar> {
  final Controller c = Get.put(Controller());

  final Task task=Task();

  bool judgeFile(String path){
    if(path.endsWith('.mp4') || path.endsWith('.mkv') || path.endsWith('.flv')){
      return true;
    }else if(path.endsWith('.mp3') || path.endsWith('acc') || path.endsWith('flac') || path.endsWith('wav')){
      return true;
    }
    return false;
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'mkv', 'flv', 'acc', 'flac', 'wav']
    );
    if (result != null) {
      final path=result.files.single.path!;
      c.fileList.add(TaskItem(path: path));
    }
  }

  Future<void> pickDir() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if(selectedDirectory!=null){
      final directory = Directory(selectedDirectory);
      List<FileSystemEntity> allFiles = directory.listSync();
      List<String> files = allFiles.where((file) {
        return file is File && judgeFile(file.path);
      }).map((file)=>file.path).toList();
      for(var path in files){
        c.fileList.add(TaskItem(path: path));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Row(
        children: [
          TopMenuBarItem(title: '添加文件', icon: Icons.add_rounded, func: ()=>pickFile(), enable: !c.running.value),
          TopMenuBarItem(title: '添加目录', icon: Icons.add_rounded, func: ()=>pickDir(), enable: !c.running.value),
          TopMenuBarItem(title: '开始当前任务', icon: Icons.play_arrow_rounded, func: ()=>task.singleRun(context), enable: !c.running.value),
          TopMenuBarItem(title: '开始所有任务', icon: Icons.play_arrow_rounded, func: ()=>task.multiRun(context), enable: !c.running.value),
          TopMenuBarItem(title: '停止', icon: Icons.stop_rounded, func: ()=>task.stop(), enable: c.running.value),
          TopMenuBarItem(title: '日志', icon: Icons.content_paste_rounded, func: ()=>task.log(context), enable: true),
        ],
      ),
    );
  }
}