import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  String encoder='H.264';

  List videoFormat=['mp4', 'mkv', 'flv'];
  List audioFormat=['mp3', 'acc', 'wav'];

  List videoEncoder=['H.264', 'H.265', 'AV1', 'MPEG-4'];
  List audioEncoder=['AAC ', 'MP3', 'FLAC'];

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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 75,
                      child: Text('来自网络'),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        splashRadius: 0,
                        value: fromNetwork, 
                        onChanged: (val){
                          setState(() {
                            fromNetwork=val;
                          });
                        }
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('输入'),
                    ),
                    Expanded(
                      child: TextField(
                        controller: input,
                        enabled: fromNetwork,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 10),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )
                          ),
                          hintText: fromNetwork ? 'http(s)://' : ''
                        ),
                        style: const TextStyle(
                          fontSize: 14
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    FilledButton(
                      onPressed: fromNetwork ? null : () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          File file = File(result.files.single.path!);
                          setState(() {
                            input.text=file.path;
                          });
                        }
                      }, 
                      child: const Text('选取')
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('编码'),
                    ),
                    SizedBox(
                      width: 120,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          items: [
                            ...List.generate(videoEncoder.length, (index){
                              return DropdownMenuItem(
                                value: videoEncoder[index],
                                child: Text(videoEncoder[index]),
                              );
                            }),
                            const DropdownMenuItem(enabled: false, child: Divider()),
                            ...List.generate(audioEncoder.length, (index){
                              return DropdownMenuItem(
                                value: audioEncoder[index],
                                child: Text(audioEncoder[index]),
                              );
                            }),
                          ],
                          value: encoder,
                          onChanged: (String? value) {
                            if(value!=null){
                              setState(() {
                                encoder = value;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('输出格式'),
                    ),
                    SizedBox(
                      width: 120,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          items: [
                            ...List.generate(videoFormat.length, (index){
                              return DropdownMenuItem(
                                value: videoFormat[index],
                                child: Text(videoFormat[index]),
                              );
                            }),
                            const DropdownMenuItem(enabled: false, child: Divider()),
                            ...List.generate(audioFormat.length, (index){
                              return DropdownMenuItem(
                                value: audioFormat[index],
                                child: Text(audioFormat[index]),
                              );
                            }),
                          ],
                          value: format,
                          onChanged: (String? value) {
                            if(value!=null){
                              setState(() {
                                format = value;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('输出文件名'),
                    ),
                    Expanded(
                      child: TextField(
                        controller: name,
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
                        ),
                        style: const TextStyle(
                          fontSize: 14
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Text('.$format')
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text('输出目录'),
                    ),
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
                        ),
                        style: const TextStyle(
                          fontSize: 14
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    FilledButton(
                      onPressed: () async {
                        String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                        if(selectedDirectory!=null){
                          setState(() {
                            output.text=selectedDirectory;
                          });
                        }
                      }, 
                      child: const Text('选取')
                    )
                  ],
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}