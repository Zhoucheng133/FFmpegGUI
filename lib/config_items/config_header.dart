import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class ConfigHeader extends StatefulWidget {
  const ConfigHeader({super.key});

  @override
  State<ConfigHeader> createState() => _ConfigHeaderState();
}

class _ConfigHeaderState extends State<ConfigHeader> {

  final Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            p.basename(controller.selectedTask.path),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 90,
                child: Text('fullPath'.tr),
              ),
              Expanded(
                child: Text(
                  controller.selectedTask.path,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}