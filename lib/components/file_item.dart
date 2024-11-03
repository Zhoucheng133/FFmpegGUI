import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;

class FilePreview extends StatefulWidget {

  final TaskItem item;
  final int index;

  const FilePreview({super.key, required this.item, required this.index});

  @override
  State<FilePreview> createState() => _FilePreviewState();
}

class _FilePreviewState extends State<FilePreview> {

  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        c.selectIndex.value=widget.index;
      },
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Obx(()=>
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: c.selectIndex.value==widget.index ? const Color.fromARGB(255, 223, 240, 198) : const Color.fromARGB(0, 223, 240, 198),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
                child: Text(
                  p.basename(widget.item.path),
                  style: GoogleFonts.notoSansSc(
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}