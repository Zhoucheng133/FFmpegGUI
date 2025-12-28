import 'package:ffmpeg_gui/service/task_item.dart';

// TODO 需要翻译

String videoEncoderToString(VideoEncoders encoder){
  switch (encoder) {
    case VideoEncoders.copy:
      return "不编码";
    case VideoEncoders.h264amf:
      return "H264 (AMD GPU加速)";
    case VideoEncoders.h264nvenc:
      return "H264 (Nvidia GPU加速)";
    case VideoEncoders.h264videotoolbox:
      return "H264 (Apple 硬件加速)";
    case VideoEncoders.hevcamf:
      return "HEVC (AMD GPU加速)";
    case VideoEncoders.hevcnvenc:
      return "HEVC (Nvidia GPU加速)";
    case VideoEncoders.hevcvideotoolbox:
      return "HEVC (Apple 硬件加速)";
    case VideoEncoders.libaomav1:
      return "AV1 (CPU)";
    case VideoEncoders.libx264:
      return "H264 (CPU)";
    case VideoEncoders.libx265:
      return "HEVC (CPU)";
    case VideoEncoders.libxvid:
      return "XviD (CPU)";
  }
}

String audioEncoderToString(AudioEncoders encoder){
  switch (encoder) {
    case AudioEncoders.aac:
      return "AAC";
    case AudioEncoders.copy:
      return "不编码";
    case AudioEncoders.flac:
      return "FLAC";
    case AudioEncoders.libmp3lame:
      return "mp3";
  }
}
