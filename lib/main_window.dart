import 'dart:io';

import 'package:ffmpeg_gui/components/config_panel.dart';
import 'package:ffmpeg_gui/components/file_list.dart';
import 'package:ffmpeg_gui/components/top_menu_bar.dart';
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

  TextEditingController output=TextEditingController();

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
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Column(
              children: [
                TopMenuBar(),
                Divider(),
                Expanded(
                  child: Row(
                    children: [
                      FileList(),
                      VerticalDivider(),
                      Expanded(child: ConfigPanel())
                    ],
                  )
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: output,
                  enabled: false,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )
                    ),
                    hintText: '输出路径'
                  ),
                  style: const TextStyle(
                    fontSize: 14
                  ),
                  autocorrect: false,
                  enableSuggestions: false,
                ),
              ),
              const SizedBox(width: 5,),
              FilledButton(onPressed: (){}, child: const Text('选取'))
            ],
          ),
        )
      ],
    );
  }
}