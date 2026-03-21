import 'package:ffmpeg_gui/components/header_button_item.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/dialogs/dialogs.dart';
import 'package:ffmpeg_gui/dialogs/settings.dart';
import 'package:ffmpeg_gui/service/command.dart';
import 'package:ffmpeg_gui/service/task_adder.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HeaderButtons extends StatefulWidget {
  const HeaderButtons({super.key});

  @override
  State<HeaderButtons> createState() => _HeaderButtonsState();
}

class _HeaderButtonsState extends State<HeaderButtons> {

  final TaskAdder taskAdder=TaskAdder();
  final Controller controller=Get.find();
  final Task task=Task();

  final GlobalKey addButtonKey = GlobalKey();

  Future<void> showRunMenu(BuildContext context) async {
    final RenderBox? renderBox = addButtonKey.currentContext?.findRenderObject() as RenderBox?;
    final width = renderBox?.size.width;

    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    Offset topLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTWH(
        topLeft.dx + width!,
        topLeft.dy + 32,
        0, 
        0,
      ),
      Offset.zero & overlay.size,
    );
    final key=await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'single',
          height: 40, 
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: FaIcon(FontAwesomeIcons.play, size: 15,)
              ),
              Text("runSingleTask".tr),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'all',
          height: 40, 
          child: Row(
            children: [
              SizedBox(
                width: 25,
                child: FaIcon(FontAwesomeIcons.play, size: 15,)
              ),
              Text("runAllTask".tr),
            ],
          ),
        ),
      ],
    );

    switch (key) {
      case 'all':
        task.singleRun(context);
        break;
      case 'single':
        task.multiRun(context);
        break;
    }
  }

  void clearAll(BuildContext context) async {
    bool? del=await confirmDialog(context, "clearAll".tr, "clearAllContent".tr);
    if(del==true){
      controller.fileList.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        children: [
          HeaderButtonItem(buttonSide: ButtonSide.left, icon: Icons.add_rounded, func: ()=>taskAdder.showAddMenu(context), text: 'addTask'.tr, disable: controller.running.value, key: addButtonKey,),
          HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.play_arrow_rounded, func: ()=>showRunMenu(context), text: 'runTask'.tr, disable: controller.running.value || controller.fileList.isEmpty,),
          HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.tune_rounded, func: (){}, text: 'applyToAll'.tr, disable: controller.running.value || controller.fileList.length<=1,),
          HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.delete_rounded, func: ()=>clearAll(context), text: 'clearAll'.tr, disable: controller.running.value || controller.fileList.isEmpty,),
          HeaderButtonItem(buttonSide: ButtonSide.right, icon: Icons.paste_rounded, func: ()=>task.log(context), text: 'log'.tr,),
          Expanded(child: Container()),
          HeaderButtonItem(buttonSide: ButtonSide.left, icon: Icons.settings_rounded, func: ()=>showSettings(context), text: 'settings'.tr,),
          HeaderButtonItem(buttonSide: ButtonSide.right, icon: Icons.info_rounded, func: ()=>showAbout(context), text: 'about'.tr,),
        ],
      ),
    );
  }
}