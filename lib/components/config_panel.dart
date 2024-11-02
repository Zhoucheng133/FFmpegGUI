import 'package:ffmpeg_gui/service/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;

class ConfigPanel extends StatefulWidget {
  const ConfigPanel({super.key});

  @override
  State<ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends State<ConfigPanel> {
  
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(()=>
          c.fileList.isNotEmpty ? 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.basename(c.fileList[c.selectIndex.value].path),
                maxLines: 2,
                style: GoogleFonts.notoSansSc(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ) : Container()
        ),
      ),
    );
  }
}