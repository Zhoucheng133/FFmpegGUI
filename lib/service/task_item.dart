import 'package:ffmpeg_gui/service/variables.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

enum Types{
  audio,
  video,
  none,
}

enum Status{
  wait,
  process,
  finished,
}

enum Formats{
  mp4,
  mkv,
  flv,
  mp3,
  aac,
  wav,
  flac,
  m4a
}

enum VideoEncoders{
  libx264,
  libx265,
  libaomav1,
  libxvid,
  copy,
  h264nvenc,
  hevcnvenc,
  h264amf,
  hevcamf,
  h264videotoolbox,
  hevcvideotoolbox,
}

enum AudioEncoders{
  aac,
  libmp3lame,
  flac,
  copy  
}

enum SubTitleType{
  none,
  file,
  embed
}

Types getType(String path){
  if(path.endsWith('.mp4') || path.endsWith('.mkv') || path.endsWith('.flv') || path.endsWith('.mov')){
      return Types.video;
    }else if(path.endsWith('.mp3') || path.endsWith('acc') || path.endsWith('flac') || path.endsWith('wav')){
      return Types.audio;
    }
    return Types.none;
}

class TaskItem{
  final Controller c = Get.put(Controller());

  // 源文件路径
  late String path;
  // 视频编码 (音频为null)
  late VideoEncoders videoEncoders;
  // 音频编码
  late AudioEncoders audioEncoders;
  // 封装
  late Formats format;
  // 声道数量, 默认为2
  int channel=2;
  // 字幕类型
  SubTitleType subTitleType=SubTitleType.none;
  // 字幕轨道
  int? subtitleTrack;
  // 字幕文件
  String subTitleFile="";
  // 文件类型
  late Types type;
  // 视频轨道, 默认为0
  int videoTrack=0;
  // 音频轨道, 默认为0
  int audioTrack=0;
  // 输出方式
  late Types outType;
  // 状态, 默认为等待
  Status status=Status.wait;
  // 分辨率宽度, 默认为null
  int? width;
  // 分辨率高度, 默认为null
  int? height;
  // 音频增益，默认为null
  int? audioVolume;
  // 输出名
  String? outputName;

  String removeExtension(String fileName){
    int lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1) {
      return fileName;
    }
    return fileName.substring(0, lastDotIndex);
  }


  TaskItem({required this.path}){
    type=getType(path);
    if(type==Types.video){
      videoEncoders=VideoEncoders.libx264;
      audioEncoders=AudioEncoders.aac;
      format=Formats.mp4;
      outType=Types.video;
    }else if(type==Types.audio){
      audioEncoders=AudioEncoders.libmp3lame;
      format=Formats.mp3;
      outType=Types.audio;
    }else{
      outType=Types.video;
      videoEncoders=VideoEncoders.libx264;
      audioEncoders=AudioEncoders.aac;
      format=Formats.mp4;
    }
    outputName=removeExtension(p.basename(path));
  }
}