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
    try {
      shell.kill();
      c.running.value=false;
    } catch (_) {}
    
  }

  void log(BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>ContentDialog(
        title: const Text('日志'),
        content: SizedBox(
          height: 300,
          width: 500,
          child: Obx(()=>ListView.builder(
            itemCount: c.log.length,
            itemBuilder: (context, index)=>Text(
              c.log[index]
            ),
          ))
        ),
        actions: [
          FilledButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: const Text('完成')
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

  Future<void> singleRun(BuildContext context) async {

    if(c.output.isEmpty){
      simpleDialog('启动失败', '输出目录不能为空', context);
      return;
    }
    String outputPath = p.join(c.output.value, '${removeExtension(p.basename(c.fileList[c.selectIndex.value].path))}.${c.fileList[c.selectIndex.value].format.toString().split('.').last}');
    File file = File(outputPath);
    if(file.existsSync()){
      simpleDialog('启动失败', '输出目录下存在相同文件', context);
      return;
    }
    String output=outputPath.replaceAll('\\', '/');
    String fileName=p.basename(c.fileList[c.selectIndex.value].path);
    String workDirectory=p.dirname(c.fileList[c.selectIndex.value].path);
    controller=ShellLinesController();
    shell=Shell(stdout: controller.sink, stderr: controller.sink, workingDirectory: workDirectory);
    var cmd='';
    if(c.fileList[c.selectIndex.value].type==Types.video){
      cmd='''
ffmpeg -i "$fileName" -c:v ${convertEncoder(c.fileList[c.selectIndex.value].encoder)} -ac ${c.fileList[c.selectIndex.value].channel} -map 0:v:${c.fileList[c.selectIndex.value].videoTrack} -map 0:a:${c.fileList[c.selectIndex.value].audioTrack} ${subtitle(fileName)} "$output"
''';
    }else{
      cmd='''
ffmpeg -i "$fileName" -c:a ${c.fileList[c.selectIndex.value].encoder.toString().split('.').last} -ac ${c.fileList[c.selectIndex.value].channel} "$output"
''';
    }
    print(cmd);
    try {
      c.running.value=true;
      controller.stream.listen((event){
        if(c.log.length>=50){
          c.log.removeAt(0);
        }
        c.log.add(event);
      });
      await shell.run(cmd);
      c.running.value=false;
    } on ShellException catch (_) {
      c.running.value=false;
    }
  }
}