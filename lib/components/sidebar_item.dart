import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/controllers/theme_controller.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Card(
        elevation: 0,
        color: themeController.buttonColor(context, false, controller.selectIndex.value==widget.index),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          hoverColor: themeController.buttonColor(context, true, controller.selectIndex.value==widget.index),
          title: Row(
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
                  style: GoogleFonts.notoSansSc(
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          onTap: (){
            controller.selectIndex.value=widget.index;
          },
        ),
      ),
    );
  }
}