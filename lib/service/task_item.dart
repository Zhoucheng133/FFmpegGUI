enum Types{
  audio,
  video,
  none,
}

enum Formats{
  mp4,
  mkv,
  flv,
  mp3,
  acc,
  wav,
  flac,
}

enum Encoders{
  libx264,
  libx265,
  libaomav1,
  libxvid,
  aac,
  libmp3lame,
  flac,
}

Types getType(String path){
  if(path.endsWith('.mp4') || path.endsWith('.mkv') || path.endsWith('.flv')){
      return Types.video;
    }else if(path.endsWith('.mp3') || path.endsWith('acc') || path.endsWith('flac') || path.endsWith('wav')){
      return Types.audio;
    }
    return Types.none;
}

class TaskItem{

  late String path;
  late Encoders encoder;
  late Formats format;
  late String? subtitle;
  late int? channel;
  late int? subtitleLine;
  late Types type;

  TaskItem({required this.path}){
    type=getType(path);
    if(type==Types.video){
      encoder=Encoders.libx264;
      format=Formats.mp4;
      subtitle=null;
      channel=null;
      subtitleLine=null;
    }else if(type==Types.audio){
      encoder=Encoders.aac;
      format=Formats.mp3;
      subtitle=null;
      channel=null;
      subtitleLine=null;
    }
  }
}