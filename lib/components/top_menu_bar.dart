import 'dart:io';

import 'package:ffmpeg_gui/components/top_menu_bar_item.dart';
import 'package:ffmpeg_gui/service/task.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show showLicensePage;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class TopMenuBar extends StatefulWidget {
  const TopMenuBar({super.key});

  @override
  State<TopMenuBar> createState() => _TopMenuBarState();
}

class _TopMenuBarState extends State<TopMenuBar> {
  final Controller c = Get.put(Controller());

  final Task task=Task();

  bool judgeFile(String path){
    if(path.endsWith('.mp4') || path.endsWith('.mkv') || path.endsWith('.flv')){
      return true;
    }else if(path.endsWith('.mp3') || path.endsWith('acc') || path.endsWith('flac') || path.endsWith('wav')){
      return true;
    }
    return false;
  }

  Future<void> pickFile() async {
    if(c.running.value){
      return;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'mkv', 'flv', 'acc', 'flac', 'wav']
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for (var element in files) {
        c.fileList.add(TaskItem(path: element.path));
      }
    }
  }

  Future<void> pickDir() async {
    if(c.running.value){
      return;
    }
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if(selectedDirectory!=null){
      final directory = Directory(selectedDirectory);
      List<FileSystemEntity> allFiles = directory.listSync();
      List<String> files = allFiles.where((file) {
        return file is File && judgeFile(file.path);
      }).map((file)=>file.path).toList();
      for(var path in files){
        c.fileList.add(TaskItem(path: path));
      }
    }
  }

  void pickNetwork(BuildContext context){
    if(c.running.value){
      return;
    }
    TextEditingController controller=TextEditingController();
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('添加任务来自网络', style: GoogleFonts.notoSansSc(),),
        content: SizedBox(
          height: 100,
          child: TextBox(
            controller: controller,
            style: GoogleFonts.notoSansSc(),
            placeholder: 'http(s)://',
            textAlignVertical: TextAlignVertical.top,
            maxLines: null,
          ),
        ),
        actions: [
          Button(
            child: Text('取消', style: GoogleFonts.notoSansSc(),), 
            onPressed: ()=>Navigator.pop(context)
          ),
          FilledButton(
            child: Text('添加', style: GoogleFonts.notoSansSc(),),
            onPressed: (){
              c.fileList.add(TaskItem(path: controller.text));
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

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

  final menuController = FlyoutController();
  final runController=FlyoutController();

  void clearTask(BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('清空任务列表', style: GoogleFonts.notoSansSc(),),
        content: Text('确定要清空任务列表吗？这个操作不能撤销！', style: GoogleFonts.notoSansSc(),),
        actions: [
          Button(
            child: Text(
              '取消', 
              style: GoogleFonts.notoSansSc(),
            ), 
            onPressed: (){
              Navigator.pop(context);
            }
          ),
          FilledButton(
            child: Text('确定', style: GoogleFonts.notoSansSc(),), 
            onPressed: (){
              Navigator.pop(context);
              c.fileList.value=[];
              c.selectIndex.value=0;
              c.fileList.refresh();
            }
          )
        ],
      )
    );
  }

  void applyAll(BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('应用配置到所有任务?', style: GoogleFonts.notoSansSc(),),
        content: Text('应用当前任务的配置到所有的任务? 注意仅限当前媒体的类型 !', style: GoogleFonts.notoSansSc(),),
        actions: [
          Button(
            child: Text('取消', style: GoogleFonts.notoSansSc(),), 
            onPressed: ()=>Navigator.pop(context)
          ),
          FilledButton(
            onPressed: (){
              final nowConfig=c.fileList[c.selectIndex.value];
              c.fileList.value=c.fileList.map((item){
                if(item.type==nowConfig.type){
                  item.encoder=nowConfig.encoder;
                  item.format=nowConfig.format;
                  item.channel=nowConfig.channel;
                  item.subtitleLine=nowConfig.subtitleLine;
                  item.videoTrack=nowConfig.videoTrack;
                  item.audioTrack=nowConfig.audioTrack;
                  item.outType=nowConfig.outType;
                  item.width=nowConfig.width;
                  item.height=nowConfig.height;
                }
                return item;
              }).toList();
              c.fileList.refresh();
              Navigator.pop(context);
            },
            child: Text('应用', style: GoogleFonts.notoSansSc(),)
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Row(
        children: [
          FlyoutTarget(
            controller: menuController,
            child: TopMenuBarItem(title: '添加', icon: FontAwesomeIcons.plus, func: (){
              menuController.showFlyout(
                autoModeConfiguration: FlyoutAutoConfiguration(
                  preferredMode: FlyoutPlacementMode.bottomRight,
                ),
                barrierDismissible: true,
                dismissOnPointerMoveAway: false,
                dismissWithEsc: true,
                builder: (context) {
                  return MenuFlyout(
                    items: [
                      MenuFlyoutItem(
                        leading: const FaIcon(FontAwesomeIcons.file),
                        text: Text('来自文件', style: GoogleFonts.notoSansSc(),),
                        onPressed: (){
                          Flyout.of(context).close();
                          pickFile();
                        }
                      ),
                      MenuFlyoutItem(
                        leading: const FaIcon(FontAwesomeIcons.folder),
                        text: Text('来自目录', style: GoogleFonts.notoSansSc(),),
                        onPressed: (){
                          Flyout.of(context).close();
                          pickDir();
                        }
                      ),
                      MenuFlyoutItem(
                        leading: const FaIcon(FontAwesomeIcons.link),
                        text: Text('来自网络', style: GoogleFonts.notoSansSc(),),
                        onPressed: (){
                          Flyout.of(context).close();
                          pickNetwork(context);
                        }
                      ),
                    ]
                  );
                }
              );
            }, enable: !c.running.value),
          ),
          FlyoutTarget(
            controller: runController,
            child: TopMenuBarItem(
              title: '开始任务', 
              icon: FontAwesomeIcons.play, 
              func: (){
                if(!c.running.value && c.fileList.isNotEmpty){
                  runController.showFlyout(
                    autoModeConfiguration: FlyoutAutoConfiguration(
                      preferredMode: FlyoutPlacementMode.bottomLeft,
                    ),
                    barrierDismissible: true,
                    dismissOnPointerMoveAway: false,
                    dismissWithEsc: true,
                    builder: (context) {
                      return MenuFlyout(
                        items: [
                          MenuFlyoutItem(
                            leading: const FaIcon(FontAwesomeIcons.play),
                            text: Text('开始当前任务', style: GoogleFonts.notoSansSc(),),
                            onPressed: (){
                              Flyout.of(context).close();
                              task.singleRun(context);
                            }
                          ),
                          MenuFlyoutItem(
                            leading: const FaIcon(FontAwesomeIcons.play),
                            text: Text('开始所有任务', style: GoogleFonts.notoSansSc(),),
                            onPressed: (){
                              Flyout.of(context).close();
                              task.multiRun(context);
                            }
                          ),
                        ]
                      );
                    }
                  );
                }
                
              }, 
              enable: !c.running.value && c.fileList.isNotEmpty
            ),
          ),
          TopMenuBarItem(title: '暂停', icon: FontAwesomeIcons.pause, func: ()=>task.pause(context, setState), enable: c.running.value && !task.stopTask),
          TopMenuBarItem(title: '停止', icon: FontAwesomeIcons.stop, func: ()=>task.stop(), enable: c.running.value),
          TopMenuBarItem(title: '清空任务', icon: FontAwesomeIcons.trash, func: ()=>clearTask(context), enable: true),
          TopMenuBarItem(title: '应用所有', icon: FontAwesomeIcons.sliders, func: ()=>applyAll(context), enable: true),
          TopMenuBarItem(title: '日志', icon: FontAwesomeIcons.clipboard, func: ()=>task.log(context), enable: true),
          // Expanded(child: Container()),
          TopMenuBarItem(title: '关于', icon: FontAwesomeIcons.circleInfo, func: ()=>showAbout(context), enable: true),
        ],
      ),
    );
  }
}