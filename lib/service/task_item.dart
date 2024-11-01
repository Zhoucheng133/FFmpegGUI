enum Types{
  audio,
  video,
  none,
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
  late String encoder;
  late String format;
  late String? subtitle;
  late int? channel;

  TaskItem({required this.path}){
    if(getType(path)==Types.video){
      encoder='libx264';
      format='mp4';
      subtitle=null;
      channel=null;
    }else if(getType(path)==Types.audio){
      encoder='aac';
      format='mp3';
      subtitle=null;
      channel=null;
    }
  }
}