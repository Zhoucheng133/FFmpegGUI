import 'package:ffmpeg_gui/components/header_button_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Expanded(
              child: Text(
                '任务配置',
                style: GoogleFonts.notoSansSc(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary
                ),
              ),
            ),
            HeaderButtonItem(buttonSide: ButtonSide.left, icon: Icons.add_rounded, func: (){}, text: '添加',),
            HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.play_arrow_rounded, func: (){}, text: '开始任务',),
            HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.delete_rounded, func: (){}, text: '清空任务',),
            HeaderButtonItem(buttonSide: ButtonSide.mid, icon: Icons.paste_rounded, func: (){}, text: '日志',),
            HeaderButtonItem(buttonSide: ButtonSide.right, icon: Icons.settings_rounded, func: (){}, text: '设置',),
          ],
        ),
        const SizedBox(height: 10,),
        Container(
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Theme.of(context).colorScheme.primary
          ),
        )
      ],
    );
  }
}