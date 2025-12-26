import 'package:ffmpeg_gui/components/header_button_item.dart';
import 'package:ffmpeg_gui/dialogs/dialogs.dart';
import 'package:flutter/material.dart';

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
            HeaderButtonItem(buttonSide: ButtonSide.left, icon: Icons.add_rounded, func: (){}, text: '添加',),
            HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.play_arrow_rounded, func: (){}, text: '开始任务',),
            HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.tune_rounded, func: (){}, text: '应用到所有',),
            HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.delete_rounded, func: (){}, text: '清空任务',),
            HeaderButtonItem(buttonSide: ButtonSide.right, icon: Icons.paste_rounded, func: (){}, text: '日志',),
            Expanded(child: Container()),
            HeaderButtonItem(buttonSide: ButtonSide.left, icon: Icons.settings_rounded, func: (){}, text: '设置',),
            HeaderButtonItem(buttonSide: ButtonSide.right, icon: Icons.info_rounded, func: ()=>showAbout(context), text: '关于',),
          ],
        ),
      ],
    );
  }
}