import 'package:ffmpeg_gui/components/header_button_item.dart';
import 'package:ffmpeg_gui/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HeaderButtons extends StatefulWidget {
  const HeaderButtons({super.key});

  @override
  State<HeaderButtons> createState() => _HeaderButtonsState();
}

class _HeaderButtonsState extends State<HeaderButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            HeaderButtonItem(buttonSide: ButtonSide.left, icon: Icons.add_rounded, func: (){}, text: 'addTask'.tr,),
            HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.play_arrow_rounded, func: (){}, text: 'runTask'.tr,),
            HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.tune_rounded, func: (){}, text: 'applyToAll'.tr,),
            HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.delete_rounded, func: (){}, text: 'clearAll'.tr,),
            HeaderButtonItem(buttonSide: ButtonSide.right, icon: Icons.paste_rounded, func: (){}, text: 'log'.tr,),
            Expanded(child: Container()),
            HeaderButtonItem(buttonSide: ButtonSide.left, icon: Icons.settings_rounded, func: (){}, text: 'settings'.tr,),
            HeaderButtonItem(buttonSide: ButtonSide.right, icon: Icons.info_rounded, func: ()=>showAbout(context), text: 'about'.tr,),
          ],
        ),
      ],
    );
  }
}