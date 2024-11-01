import 'dart:io';

import 'package:ffmpeg_gui/components/top_menu_bar.dart';
import 'package:ffmpeg_gui/service/task.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import 'package:process_run/which.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {

  void init(){
    var ffmpegExectutable = whichSync('ffmpeg');
    if(ffmpegExectutable==null){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context, 
          builder: (BuildContext context)=>AlertDialog(
            title: const Text('没有找到FFmpeg'), 
            content: const Text('没有找到FFmpeg的位置，请确定将其加入到系统环境变量'),
            actions: [
              FilledButton(
                onPressed: (){
                  windowManager.close();
                },
                child: const Text('好的')
              )
            ],
          )
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    init();
  }

  bool fromNetwork=false;
  TextEditingController input=TextEditingController();
  TextEditingController output=TextEditingController();
  String format='mp4';
  TextEditingController name=TextEditingController();
  String encoder='libx264';

  List videoFormat=['mp4', 'mkv', 'flv'];
  List audioFormat=['mp3', 'acc', 'wav'];

  List videoEncoder=['libx264', 'libx265', 'libaom-av1', 'libxvid'];
  List audioEncoder=['aac ', 'libmp3lame', 'flac'];

  Task task=Task();
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              TopMenuBar(),
            ],
          ),
        )
      ],
    );
  }
}