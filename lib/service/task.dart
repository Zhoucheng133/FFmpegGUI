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

  void pause(BuildContext context, setState){
    if(!c.running.value || stopTask){
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
              setState((){
                stopTask=true;
              });
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

  String subtitle(String fileName, TaskItem item){
    if(item.subTitleType==SubTitleType.none){
      return "";
    }else if(item.subTitleType==SubTitleType.embed){
      return '''-vf "subtitles='$fileName':si=${c.fileList[c.selectIndex.value].subtitleTrack}"''';
    }else{
      return '''-vf "ass='${p.basename(item.subTitleFile)}'"''';
    }
  }

  String convertEncoder(VideoEncoders videoEncoder){
    if(videoEncoder==VideoEncoders.libaomav1){
      return 'libaom-av1';
    }
    return videoEncoder.toString().split('.').last;
  }

  String scale(int? index){
    TaskItem item=c.fileList[index??c.selectIndex.value];
    if(item.width!=null && item.height!=null){
      return ' -s ${item.width}x${item.height}';
    }
    return '';
  }

  String audioVolume(int? index){
    TaskItem item=c.fileList[index??c.selectIndex.value];
    if(item.audioVolume!=null){
      return ' -af "volume=${item.audioVolume}"';
    }
    return "";
  }

  Future<void> mainService(int? index) async {
    TaskItem item=c.fileList[index??c.selectIndex.value];
    String outputPath='';
    String fileName='';
    String workDirectory='';
    controller=ShellLinesController(encoding: utf8);
    outputPath=p.join(c.output.value, '${item.outputName}.${item.format.name}');
    if(item.path.startsWith('http')){
      fileName=item.path;
      shell=Shell(stdout: controller.sink, stderr: controller.sink);
    }else{
      fileName=p.basename(item.path);
      workDirectory=p.dirname(item.path);
      shell=Shell(stdout: controller.sink, stderr: controller.sink, workingDirectory: item.subTitleType==SubTitleType.file ? p.dirname(item.subTitleFile) : workDirectory);
    }
    String output=outputPath.replaceAll('\\', '/');
    runIndex=index??-1;
    var cmd='';
    if(item.outType==Types.video){
      cmd='''
${c.ffmpeg.value} -i "${item.subTitleType==SubTitleType.file ? item.path.replaceAll("\\", "/") : fileName}" -c:v ${convertEncoder(item.videoEncoders)}${scale(index)}${audioVolume(index)} -c:a ${item.audioEncoders.toString().split('.').last} -ac ${item.channel} -map 0:v:${item.videoTrack} -map 0:a:${item.audioTrack} ${subtitle(fileName, item)} "$output"
''';
    }else if(item.outType==Types.audio){
        cmd='''
${c.ffmpeg.value} -i "$fileName" -c:a ${item.audioEncoders.toString().split('.').last} -ac ${item.channel} "$output"
''';
    }else{
      cmd='''
${c.ffmpeg.value} -i "$fileName" "$output"
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
      // String outputPath = p.join(c.output.value, '${removeExtension(p.basename(c.fileList[index].path))}.${c.fileList[index].format.toString().split('.').last}');
      String outputPath=p.join(c.output.value, '${c.fileList[index].outputName}.${c.fileList[index].format.name}');
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
    String outputPath=p.join(c.output.value, '${c.fileList[c.selectIndex.value].outputName}.${c.fileList[c.selectIndex.value].format.name}');
    // String outputPath = p.join(c.output.value, '${removeExtension(p.basename(c.fileList[c.selectIndex.value].path))}.${c.fileList[c.selectIndex.value].format.toString().split('.').last}');
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