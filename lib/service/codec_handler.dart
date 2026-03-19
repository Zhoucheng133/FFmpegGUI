import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:get/get.dart';

String videoEncoderToString(VideoEncoders encoder){
  switch (encoder) {
    case VideoEncoders.copy:
      return "noCoding".tr;
    case VideoEncoders.libx264:
      return "H264_CPU".tr;
    case VideoEncoders.h264amf:
      return "H264_AMD".tr;
    case VideoEncoders.h264nvenc:
      return "H264_NVIDIA".tr;
    case VideoEncoders.h264videotoolbox:
      return "H264_Apple".tr;
    case VideoEncoders.libx265:
      return "H265_CPU".tr;
    case VideoEncoders.hevcamf:
      return "H265_AMD".tr;
    case VideoEncoders.hevcnvenc:
      return "H265_NVIDIA".tr;
    case VideoEncoders.hevcvideotoolbox:
      return "H265_Apple".tr;
    case VideoEncoders.libaomav1:
      return "AV1".tr;
    case VideoEncoders.libxvid:
      return "XviD".tr;
  }
}

String audioEncoderToString(AudioEncoders encoder){
  switch (encoder) {
    case AudioEncoders.aac:
      return "AAC";
    case AudioEncoders.copy:
      return "noCoding".tr;
    case AudioEncoders.flac:
      return "FLAC";
    case AudioEncoders.libmp3lame:
      return "mp3";
  }
}
