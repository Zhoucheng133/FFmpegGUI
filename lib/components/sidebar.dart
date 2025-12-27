import 'package:ffmpeg_gui/components/sidebar_item.dart';
import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {

  final Controller controller=Get.find();
  final ThemeController themeController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10),
      child: Obx(
        () => ListView.builder(
          itemCount: controller.fileList.length,
          itemBuilder: (BuildContext context, int index)=>SidebarItem(
            item: controller.fileList[index],
            index: index,
          ),
        ),
      )
    );
  }
}