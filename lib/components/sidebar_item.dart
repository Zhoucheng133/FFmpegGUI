import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/controllers/theme_controller.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class SidebarItem extends StatefulWidget {

  final TaskItem item;
  final int index;

  const SidebarItem({super.key, required this.item, required this.index});

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {

  final controller=Get.find<Controller>();
  final ThemeController themeController=Get.find();

  Future<void> showTaskMenu(BuildContext context, TapDownDetails details) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    var val=await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 50,
        position.dy + 50,
      ),
      items: [
        PopupMenuItem(
          value: 'reset',
          height: 40, 
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: FaIcon(FontAwesomeIcons.rotate, size: 15,)
              ),
              Text("resetTaskStatus".tr),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          height: 40, 
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: FaIcon(FontAwesomeIcons.trash, size: 15,)
              ),
              Text("deleteTask".tr),
            ],
          ),
        ),
      ]
    );

    if(val=='delete'){
      controller.fileList.removeAt(widget.index);
      controller.selectIndex.value=0;
      controller.fileList.refresh();
    }else if(val=='reset'){
      controller.fileList[widget.index].status=Status.wait;
      controller.fileList.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (detail)=>showTaskMenu(context, detail),
      child: Obx(
        ()=> Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Material(
            color: themeController.buttonColor(context, false, controller.selectIndex.value==widget.index),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              hoverColor: themeController.buttonColor(context, true, controller.selectIndex.value==widget.index),
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          p.basename(widget.item.path,),
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: (){
                controller.selectIndex.value=widget.index;
              },
            ),
          ),
        ),
      ),
    );
  }
}