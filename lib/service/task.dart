import 'dart:io';

import 'package:ffmpeg_gui/service/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/process_run.dart';
import 'package:path/path.dart' as p;

class Task {
  late Shell shell;
  final Controller c = Get.put(Controller());
  var controller = ShellLinesController();

  void simpleDialog(String title, String content, BuildContext context){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          FilledButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: const Text('好的')
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
      builder: (context)=>AlertDialog(
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

  Future<void> run(String input, String output, String format, String encoder, String name, BuildContext context) async {

    if(input.isEmpty){
      simpleDialog('启动失败', '输入内容不能为空', context);
      return;
    }else if(output.isEmpty){
      simpleDialog('启动失败', '输出内容不能为空', context);
      return;
    }else if(name.isEmpty){
      simpleDialog('启动失败', '输出文件名不能为空', context);
      return;
    }

    String path = p.join(output, '$name.$format');
    File file = File(path);
    if(file.existsSync()){
      simpleDialog('启动失败', '输出目录下存在相同文件', context);
      return;
    }

    output=output.replaceAll('\\', '/');
    String fileName=p.basename(input);
    String workDirectory=p.dirname(input);

    shell=Shell(stdout: controller.sink, stderr: controller.sink, workingDirectory: workDirectory);

    var cmd="";
    if(format=='mp4' || format=='flv' || format=='mkv'){
      cmd='''
ffmpeg -i "$fileName" -c:v $encoder "$output/$name.$format"
''';
    }
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
    } on ShellException catch (_) {}
  }
}