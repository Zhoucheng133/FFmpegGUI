import 'package:ffmpeg_gui/components/top_menu_bar_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopMenuBar extends StatefulWidget {
  const TopMenuBar({super.key});

  @override
  State<TopMenuBar> createState() => _TopMenuBarState();
}

class _TopMenuBarState extends State<TopMenuBar> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(()=>TopMenuBarItem(title: '开始当前任务', icon: Icons.play_arrow_rounded, func: (){}, enable: !c.running.value)),
        Obx(()=>TopMenuBarItem(title: '开始所有任务', icon: Icons.play_arrow_rounded, func: (){}, enable: !c.running.value)),
        Obx(()=>TopMenuBarItem(title: '停止', icon: Icons.stop_rounded, func: (){}, enable: c.running.value))

      ],
    );
  }
}