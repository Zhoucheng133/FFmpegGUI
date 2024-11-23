import 'package:ffmpeg_gui/components/file_item.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FileList extends StatefulWidget {
  const FileList({super.key});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  final Controller c = Get.put(Controller());

  int finishedCount(){
    int cnt=0;
    for (var element in c.fileList) {
      if(element.status==Status.finished){
        cnt+=1;
      }
    }
    return cnt;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(()=>
            Text(
              '任务${c.fileList.length}个, 已完成${finishedCount()}个',
              style: GoogleFonts.notoSansSc(),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 5,),
          Expanded(
            child: Obx(()=>
              ListView.builder(
                itemCount: c.fileList.length,
                itemBuilder: (context, index)=>FilePreview(item: c.fileList[index], index: index)
              )
            ),
          ),
        ],
      )
    );
  }
}