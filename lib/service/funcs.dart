import 'package:ffmpeg_gui/service/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show showLicensePage;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Funcs {

  final Controller c = Get.put(Controller());

  void showAbout(BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('关于FFmpeg GUI', style: GoogleFonts.notoSansSc(),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset('assets/icon.png')
              ),
            ),
            Text(
              'FFmpeg GUI', 
              style: GoogleFonts.notoSansSc(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              c.version,
              style: GoogleFonts.notoSansSc(
                color: Colors.grey[80],
              ),
            ),
            const SizedBox(height: 15,),
            GestureDetector(
              onTap: () async {
                final Uri url = Uri.parse('https://github.com/Zhoucheng133/FFmpegGUI');
                await launchUrl(url);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.github,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      '本项目地址',
                      style:  GoogleFonts.notoSansSc(),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: () => showLicensePage(context: context),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.certificate,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      '许可证',
                      style:  GoogleFonts.notoSansSc(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        actions: [
          FilledButton(
            child: Text('好的', style: GoogleFonts.notoSansSc(),), 
            onPressed: (){
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  Future<void> showFFmpegSetting(BuildContext context) async {
    TextEditingController controller=TextEditingController();
    controller.text=c.ffmpeg.value;
    await showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('设置FFmpeg的环境变量', style: GoogleFonts.notoSansSc(),),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 30,
                    child: TextBox(
                      maxLines: 1,
                      controller: controller,
                    ),
                  )
                ),
                const SizedBox(width: 10,),
                Button(
                  child: Text('选取', style: GoogleFonts.notoSansSc(),), 
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                    if (result != null) {
                      // File file = File(result.files.single.path!);
                      setState((){
                        controller.text=result.files.single.path!;
                      });
                    }
                  }
                )
              ],
            );
          }
        ),
        actions: [
          FilledButton(
            child: Text('完成', style: GoogleFonts.notoSansSc(),), 
            onPressed: () async {
              c.ffmpeg.value=controller.text;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('ffmpeg', controller.text);
              if(context.mounted){
                Navigator.pop(context);
              }
            }
          )
        ],
      )
    );
  }
}