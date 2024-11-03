import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:fluent_ui/fluent_ui.dart';
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
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '完整路径',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      c.fileList[c.selectIndex.value].path
                    )
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '编码',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  ComboBox(
                    value: c.fileList[c.selectIndex.value].encoder,
                    items: [
                      ComboBoxItem(
                        value: Encoders.libx264,
                        enabled: c.fileList[c.selectIndex.value].type==Types.video,
                        child: Text('libx264', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.libx265,
                        enabled: c.fileList[c.selectIndex.value].type==Types.video,
                        child: Text('libx265', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.libaomav1,
                        enabled: c.fileList[c.selectIndex.value].type==Types.video,
                        child: Text('libaomav1', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.libxvid,
                        enabled: c.fileList[c.selectIndex.value].type==Types.video,
                        child: Text('libxvid', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.aac,
                        enabled: c.fileList[c.selectIndex.value].type==Types.audio,
                        child: Text('aac', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.libmp3lame,
                        enabled: c.fileList[c.selectIndex.value].type==Types.audio,
                        child: Text('libmp3lame', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.flac,
                        enabled: c.fileList[c.selectIndex.value].type==Types.audio,
                        child: Text('flac', style: GoogleFonts.notoSansSc(),),
                      )
                    ],
                    onChanged: (value){
                      if(value!=null){
                        c.fileList[c.selectIndex.value].encoder=value;
                      }
                    },
                  ),
                ],
              ),
            ],
          ) : Container()
        ),
      ),
    );
  }
}