import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  final contextController = FlyoutController();
  final contextAttachKey = GlobalKey();

  Future<void> menu(BuildContext context, TapDownDetails details) async {
    final targetContext = contextAttachKey.currentContext;
    if (targetContext == null) return;
    final box = targetContext.findRenderObject() as RenderBox;
    final position = box.localToGlobal(
      details.localPosition,
      ancestor: Navigator.of(context).context.findRenderObject(),
    );
    contextController.showFlyout(
      barrierColor: Colors.black.withOpacity(0.1),
      position: position,
      builder: (context) {
        return MenuFlyout(
          items: [
            MenuFlyoutItem(
              leading: const FaIcon(FontAwesomeIcons.trash),
              text: Text('删除', style: GoogleFonts.notoSansSc(),),
              onPressed: () {
                Flyout.of(context).close();
                if(c.selectIndex.value>=widget.index){
                  c.selectIndex.value=0;
                }
                c.fileList.removeAt(widget.index);
                c.fileList.refresh();
              },
            ),
            if(c.fileList[widget.index].status==Status.finished) MenuFlyoutItem(
              leading: const FaIcon(FontAwesomeIcons.rotateRight),
              text: Text('重置状态', style: GoogleFonts.notoSansSc(),),
              onPressed: () {
                Flyout.of(context).close();
                c.fileList[widget.index].status=Status.wait;
                c.fileList.refresh();
              },
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (val) => menu(context, val),
      onTap: (){
        c.selectIndex.value=widget.index;
      },
      child: FlyoutTarget(
        key: contextAttachKey,
        controller: contextController,
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
                  child: Row(
                    children: [
                      widget.item.status==Status.wait ? const FaIcon(
                        FontAwesomeIcons.clock,
                        size: 13,
                      ) : widget.item.status==Status.finished ? const FaIcon(
                        FontAwesomeIcons.circleCheck,
                        size: 13,
                      ) : const FaIcon(
                        FontAwesomeIcons.hourglassHalf,
                        size: 13,
                      ),
                      const SizedBox(width: 7,),
                      Expanded(
                        child: Text(
                          p.basename(widget.item.path),
                          style: GoogleFonts.notoSansSc(
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}