import 'package:ffmpeg_gui/components/header_button_item.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/dialogs/dialogs.dart';
import 'package:ffmpeg_gui/dialogs/settings.dart';
import 'package:ffmpeg_gui/service/command.dart';
import 'package:ffmpeg_gui/service/task_adder.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
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
        task.multiRun(context);
        break;
      case 'single':
        task.singleRun(context);
        break;
    }
  }

  void clearAll(BuildContext context) async {
    bool? del=await confirmDialog(context, "clearAll".tr, "clearAllContent".tr);
    if(del==true){
      controller.fileList.clear();
    }
  }

  void applyToAll(BuildContext context) async {
    bool? apply=await confirmDialog(context, "applyToAll".tr, "applyToAllContent".tr);
    if(apply==true){
      final nowConfig=controller.fileList[controller.selectIndex.value];
      controller.fileList.value=controller.fileList.map((item){
        if(item.type==nowConfig.type){
          item.videoEncoders=nowConfig.videoEncoders;
          item.audioEncoders=nowConfig.audioEncoders;
          item.format=nowConfig.format;
          item.channel=nowConfig.channel;
          item.videoTrack=nowConfig.videoTrack;
          item.audioTrack=nowConfig.audioTrack;
          item.outType=nowConfig.outType;
          item.width=nowConfig.width;
          item.height=nowConfig.height;
          item.audioVolume=nowConfig.audioVolume;
          if(nowConfig.subTitleType==SubTitleType.embed){
            item.subTitleType=SubTitleType.embed;
            item.subtitleTrack=nowConfig.subtitleTrack;
          }
        }
        return item;
      }).toList();
      controller.fileList.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Row(
        children: [
          HeaderButtonItem(buttonSide: ButtonSide.left, icon: Icons.add_rounded, func: ()=>taskAdder.showAddMenu(context), text: 'addTask'.tr, disable: controller.running.value, key: addButtonKey,),
          HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.play_arrow_rounded, func: ()=>showRunMenu(context), text: 'runTask'.tr, disable: controller.running.value || controller.fileList.isEmpty,),
          HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.tune_rounded, func: ()=>applyToAll(context), text: 'applyToAll'.tr, disable: controller.running.value || controller.fileList.length<=1,),
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