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

  Future<void> menu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    var val = await showMenu(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 50,
        position.dy + 50,
      ),
      items: [
        const PopupMenuItem(
          value: "del",
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_rounded,
                size: 18,
              ),
              SizedBox(width: 5),
              Text('删除'),
            ],
          ),
        ),
      ],
    );
    if(val=='del'){
      c.fileList.removeAt(widget.index);
      c.fileList.refresh();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (val) => menu(context, val),
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