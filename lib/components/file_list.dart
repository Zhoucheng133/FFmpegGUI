// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ffmpeg_gui/components/file_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FileList extends StatefulWidget {
  const FileList({super.key});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Expanded(
        child: Obx(()=>
          ListView.builder(
            itemCount: c.fileList.length,
            itemBuilder: (context, index)=>FilePreview(item: c.fileList[index], index: index)
          )
        ),
      )
    );
  }
}