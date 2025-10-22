import 'package:ffmpeg_gui/service/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show showLicensePage;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Funcs {

  final Controller c = Get.put(Controller());

  Future<void> showAbout(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if(context.mounted){
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
                "v${packageInfo.version}",
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
                onTap: () => showLicensePage(
                  applicationName: 'FFmpeg GUI',
                  applicationVersion: 'v${packageInfo.version}',
                  context: context
                ),
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
  }

  Future<void> showFFmpegSetting(BuildContext context) async {

    TextEditingController controller=TextEditingController();
    controller.text=c.ffmpeg.value;

    await showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('设置', style: GoogleFonts.notoSansSc(),),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Checkbox(
                    checked: c.useNotification.value,
                    onChanged: (bool? value) async {
                      c.useNotification.value=value??false;
                      final SharedPreferences prefs=await SharedPreferences.getInstance();
                      prefs.setBool('useNotification', c.useNotification.value);
                    },
                    content: Text('启用通知', style: GoogleFonts.notoSansSc(),),
                  ),
                ),
                const SizedBox(height: 10,),
                Text("FFmpeg路径", style: GoogleFonts.notoSansSc(),),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: TextBox(
                          maxLines: 1,
                          controller: controller,
                          style: GoogleFonts.notoSansSc(
                            fontSize: 14
                          ),
                        ),
                      )
                    ),
                    const SizedBox(width: 10,),
                    Button(
                      child: Text('选取', style: GoogleFonts.notoSansSc(),), 
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          setState((){
                            controller.text=result.files.single.path!;
                          });
                        }
                      }
                    )
                  ],
                ),
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