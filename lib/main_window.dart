import 'dart:io';

import 'package:ffmpeg_gui/components/config_panel.dart';
import 'package:ffmpeg_gui/components/file_list.dart';
import 'package:ffmpeg_gui/components/top_menu_bar.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:process_run/which.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {

  late SharedPreferences prefs;

  Future<void> init() async {
    await windowManager.setPreventClose(true);
    var ffmpegExectutable = whichSync('ffmpeg');
    prefs = await SharedPreferences.getInstance();
    final prefOutput=prefs.getString('output');
    if(prefOutput!=null){
      output.text=prefOutput;
      c.output.value=prefOutput;
      c.output.refresh();
    }
    if(ffmpegExectutable==null){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context, 
          builder: (BuildContext context)=>ContentDialog(
            title: Text('没有找到FFmpeg', style: GoogleFonts.notoSansSc(),), 
            content: Text('没有找到FFmpeg的位置，请确定将其加入到系统环境变量', style: GoogleFonts.notoSansSc(),),
            actions: [
              FilledButton(
                onPressed: (){
                  windowManager.close();
                },
                child: Text('好的', style: GoogleFonts.notoSansSc(),)
              )
            ],
          )
        );
      });
    }
  }

  @override
  void onWindowClose() async{
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      if(c.running.value){
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (_) {
            return ContentDialog(
              title: Text('任务正在进行中', style: GoogleFonts.notoSansSc(),),
              content: Text('你需要等待任务完成或者停止任务才能退出', style: GoogleFonts.notoSansSc(),),
              actions: [
                FilledButton(
                  child: Text('好的', style: GoogleFonts.notoSansSc(),),
                  onPressed: (){
                    Navigator.pop(context);
                  }
                )
              ],
            );
          },
        );
      }else{
        await windowManager.setPreventClose(false);
        await windowManager.close();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    init();
  }

  TextEditingController output=TextEditingController();

  final Controller c = Get.put(Controller());

  Future<void> selectOutput() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if(selectedDirectory!=null){
      setState(() {
        output.text=selectedDirectory;
      });
      c.output.value=selectedDirectory;
      prefs.setString('output', output.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 247, 251, 241),
      child: Column(
        children: [
          Container(
            height: 30,
            color: Colors.transparent,
            child: Platform.isWindows ? Row(
              children: [
                Expanded(child: DragToMoveArea(child: Container())),
                WindowCaptionButton.minimize(onPressed: ()=>windowManager.minimize(),),
                WindowCaptionButton.close(onPressed: ()=>windowManager.close(),)
              ],
            ) : DragToMoveArea(child: Container())
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Column(
                children: [
                  TopMenuBar(),
                  Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Divider(),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        FileList(),
                        SizedBox(width: 5,),
                        Expanded(child: ConfigPanel())
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextBox(
                    controller: output,
                    enabled: false,
                    style: GoogleFonts.notoSansSc(
                      fontSize: 14
                    ),
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                ),
                const SizedBox(width: 5,),
                FilledButton(
                  onPressed: ()=>selectOutput(), 
                  child: Text(
                    '选取', 
                    style: GoogleFonts.notoSansSc(),
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}