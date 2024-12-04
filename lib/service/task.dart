import 'dart:convert';
import 'dart:io';

import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:process_run/process_run.dart';
import 'package:path/path.dart' as p;

class Task {
  late Shell shell;
  final Controller c = Get.put(Controller());
  late ShellLinesController controller;
  bool stopTask=false;
  int runIndex=-1;

  void pause(BuildContext context){
    if(!c.running.value){
      return;
    }
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('暂停运行', style: GoogleFonts.notoSansSc(),),
        content: Text('在当前正在执行的任务结束之后暂停任务的执行', style: GoogleFonts.notoSansSc(),),
        actions: [
          Button(
            child: Text('取消', style: GoogleFonts.notoSansSc(),),
            onPressed: (){
              Navigator.pop(context);
            }
          ),
          FilledButton(
            child: Text('继续', style: GoogleFonts.notoSansSc(),),
            onPressed: (){
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  void simpleDialog(String title, String content, BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text(title, style: GoogleFonts.notoSansSc()),
        content: Text(content, style: GoogleFonts.notoSansSc()),
        actions: [
          FilledButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('好的', style: GoogleFonts.notoSansSc(),)
          )
        ],
      )
    );
  }

  void stop(){
    if(!c.running.value){
      return;
    }
    stopTask=true;
    try {
      shell.kill();
      c.running.value=false;
      c.log.value=[];
    } catch (_) {}
  }

  String convertName(int index){
    if(c.fileList[index].path.startsWith("http")){
      return c.fileList[index].path;
    }
    return p.basename(c.fileList[index].path);
  }

  void log(BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: Text('日志', style: GoogleFonts.notoSansSc(),),
        content: SizedBox(
          height: 300,
          width: 500,
          child: Obx(()=>Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '正在执行的任务: ${c.running.value ? runIndex==-1 ? convertName(c.selectIndex.value) : convertName(runIndex) : '/'}',
                style: GoogleFonts.notoSansSc(
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Divider(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: c.log.length,
                  itemBuilder: (context, index)=>Text(
                    c.log[index],
                    style: GoogleFonts.notoSansSc(),
                  ),
                ),
              ),
            ],
          ))
        ),
        actions: [
          FilledButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('完成', style: GoogleFonts.notoSansSc(),)
          )
        ],
      )
    );
  }

  String removeExtension(String fileName){
    int lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1) {
      return fileName;
    }
    return fileName.substring(0, lastDotIndex);
  }

  String subtitle(String fileName){
    if(c.fileList[c.selectIndex.value].subtitleLine==null){
      return "";
    }
    return '''-vf "subtitles='$fileName':si=${c.fileList[c.selectIndex.value].subtitleLine}"''';
  }

  String convertEncoder(Encoders encoder){
    if(encoder==Encoders.libaomav1){
      return 'libaom-av1';
    }
    return encoder.toString().split('.').last;
  }

  String scale(int? index){
    TaskItem item=c.fileList[index??c.selectIndex.value];
    if(item.width!=null && item.height!=null){
      return ' -s ${item.width}x${item.height}';
    }
    return '';
  }

  Future<void> mainService(int? index) async {
    TaskItem item=c.fileList[index??c.selectIndex.value];
    String outputPath='';
    String fileName='';
    String workDirectory='';
    controller=ShellLinesController(encoding: utf8);
    if(item.path.startsWith('http')){
      outputPath = p.join(c.output.value, 'index${index ?? c.selectIndex.value}.${item.format.toString().split('.').last}');
      fileName=item.path;
      shell=Shell(stdout: controller.sink, stderr: controller.sink);
    }else{
      outputPath = p.join(c.output.value, '${removeExtension(p.basename(item.path))}.${item.format.toString().split('.').last}');
      fileName=p.basename(item.path);
      workDirectory=p.dirname(item.path);
      shell=Shell(stdout: controller.sink, stderr: controller.sink, workingDirectory: workDirectory);
    }
    String output=outputPath.replaceAll('\\', '/');
    runIndex=index??-1;
    var cmd='';
    if(item.outType==Types.video){
      cmd='''
ffmpeg -i "$fileName" -c:v ${convertEncoder(item.encoder)}${scale(index)} -ac ${item.channel} -map 0:v:${item.videoTrack} -map 0:a:${item.audioTrack} ${subtitle(fileName)} "$output"
''';
    }else if(item.outType==Types.audio){
      cmd='''
ffmpeg -i "$fileName" -c:a ${item.encoder.toString().split('.').last} -ac ${item.channel} "$output"
''';
    }else{
      cmd='''
ffmpeg -i "$fileName" "$output"
''';
    }
    // print(cmd);
    try {
      c.running.value=true;
      controller.stream.listen((event){
        if(c.log.length>=50){
          c.log.removeAt(0);
        }
        c.log.insert(0, event);
      });
      c.fileList[index??c.selectIndex.value].status=Status.process;
      c.fileList.refresh();
      await shell.run(cmd);
      c.fileList[index??c.selectIndex.value].status=Status.finished;
      c.fileList.refresh();
    } on ShellException catch (_) {
      c.fileList[index??c.selectIndex.value].status=Status.wait;
      c.fileList.refresh();
    }
  }

  Future<void> multiRun(BuildContext context) async {
    if(c.running.value || c.fileList.isEmpty){
      return;
    }else if(c.output.isEmpty){
      simpleDialog('启动失败', '输出目录不能为空', context);
      return;
    }
    c.log.value=[];
    for(int index=0; index<c.fileList.length; index++){
      String outputPath = p.join(c.output.value, '${removeExtension(p.basename(c.fileList[index].path))}.${c.fileList[index].format.toString().split('.').last}');
      File file = File(outputPath);
      if(c.fileList[index].status==Status.finished){
        continue;
      }
      if(file.existsSync()){
        if(context.mounted){
          simpleDialog('启动失败', '输出目录下存在相同文件: $outputPath', context);
        }
        continue;
      }
      if(stopTask){
        break;
      }
      await mainService(index);
    }
    c.running.value=false;
    stopTask=false;
  }

  Future<void> singleRun(BuildContext context) async {
    if(c.running.value || c.fileList.isEmpty){
      return;
    }else if(c.output.isEmpty){
      simpleDialog('启动失败', '输出目录不能为空', context);
      return;
    }else if(c.fileList[c.selectIndex.value].status==Status.finished){
      simpleDialog('启动失败', '当前任务已完成', context);
      return;
    }
    String outputPath = p.join(c.output.value, '${removeExtension(p.basename(c.fileList[c.selectIndex.value].path))}.${c.fileList[c.selectIndex.value].format.toString().split('.').last}');
    File file = File(outputPath);
    if(file.existsSync()){
      simpleDialog('启动失败', '输出目录下存在相同文件', context);
      return;
    }
    c.log.value=[];
    await mainService(null);
    c.running.value=false;
    stopTask=false;
  }
}