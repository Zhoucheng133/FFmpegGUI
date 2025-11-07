import 'dart:io';

import 'package:ffmpeg_gui/components/sub_dialog.dart';
import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:ffmpeg_gui/service/variables.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;

class ConfigPanel extends StatefulWidget {
  const ConfigPanel({super.key});

  @override
  State<ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends State<ConfigPanel> {
  
  final Controller c = Get.put(Controller());
  final nameController=TextEditingController();

  void setName(){
    if(c.fileList.isNotEmpty){
      setState(() {
        nameController.text=c.fileList[c.selectIndex.value].outputName!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ever(c.fileList, (_)=>setName());
    ever(c.selectIndex, (_)=>setName());
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(()=>
          c.fileList.isNotEmpty ? 
          ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.fileList[c.selectIndex.value].path.startsWith('http') ? c.fileList[c.selectIndex.value].path : p.basename(c.fileList[c.selectIndex.value].path),
                maxLines: 2,
                style: GoogleFonts.notoSansSc(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '完整路径',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      c.fileList[c.selectIndex.value].path,
                      style: GoogleFonts.notoSansSc(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '输出',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  ComboBox(
                    value: c.fileList[c.selectIndex.value].outType,
                    items: [
                      ComboBoxItem(
                        value: Types.video,
                        enabled: c.fileList[c.selectIndex.value].type==Types.video,
                        child: Text('视频', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Types.audio,
                        child: Text('音频', style: GoogleFonts.notoSansSc(),),
                      ),
                    ],
                    onChanged: (value){
                      if(value!=null){
                        c.fileList[c.selectIndex.value].outType=value;
                        if(c.fileList[c.selectIndex.value].outType==Types.video){
                          c.fileList[c.selectIndex.value].format=Formats.mp4;
                          c.fileList[c.selectIndex.value].videoEncoders=VideoEncoders.libx264;
                          c.fileList[c.selectIndex.value].audioEncoders=AudioEncoders.aac;
                        }else if(c.fileList[c.selectIndex.value].outType==Types.audio){
                          c.fileList[c.selectIndex.value].format=Formats.mp3;
                          c.fileList[c.selectIndex.value].audioEncoders=AudioEncoders.libmp3lame;
                        }
                        c.fileList.refresh();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '编码',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  Row(
                    children: [
                      if(c.fileList[c.selectIndex.value].outType==Types.video) ComboBox(
                        value: c.fileList[c.selectIndex.value].videoEncoders,
                        items: VideoEncoders.values
                        .where((item){
                          final excludedEncoders = Platform.isMacOS
                          ? [VideoEncoders.h264nvenc, VideoEncoders.hevcnvenc, VideoEncoders.h264amf, VideoEncoders.hevcamf]
                          : [VideoEncoders.h264videotoolbox, VideoEncoders.hevcvideotoolbox];

                          return !excludedEncoders.contains(item);
                        })
                        .map((item)=>ComboBoxItem(
                          value: item,
                          child: Text(
                            videoEncoderToString(item),
                            style: GoogleFonts.notoSansSc()
                          )
                        )).toList(),
                        onChanged: (value){
                          value=value as VideoEncoders;
                          c.fileList[c.selectIndex.value].videoEncoders=value;
                          c.fileList.refresh();
                        },
                      ),
                      if(c.fileList[c.selectIndex.value].outType==Types.video) const SizedBox(width: 10,),
                      ComboBox(
                        value: c.fileList[c.selectIndex.value].audioEncoders,
                        items: AudioEncoders.values.map((item)=>ComboBoxItem(
                          value: item,
                          child: Text(
                            audioEncoderToString(item),
                            style: GoogleFonts.notoSansSc(),
                          )
                        )).toList(),
                        onChanged: (value){
                          value=value as AudioEncoders;
                          c.fileList[c.selectIndex.value].audioEncoders=value;
                          c.fileList.refresh();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '格式',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  ComboBox(
                    value: c.fileList[c.selectIndex.value].format,
                    items: c.fileList[c.selectIndex.value].outType==Types.video ? [
                      ComboBoxItem(
                        value: Formats.mp4,
                        child: Text('mp4', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.mkv,
                        child: Text('mkv', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.flv,
                        enabled: c.fileList[c.selectIndex.value].videoEncoders!=VideoEncoders.libaomav1,
                        child: Text('flv', style: GoogleFonts.notoSansSc(),),
                      ),
                    ] : [
                      ComboBoxItem(
                        value: Formats.mp3,
                        child: Text('mp3', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.aac,
                        child: Text('aac', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.wav,
                        child: Text('wav', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.m4a,
                        child: Text('m4a', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.flac,
                        child: Text('flac', style: GoogleFonts.notoSansSc(),),
                      ),
                    ],
                    onChanged: (value){
                      if(value!=null){
                        c.fileList[c.selectIndex.value].format=value;
                        c.fileList.refresh();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '截取',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  Checkbox(
                    checked: c.fileList[c.selectIndex.value].enableClip,
                    onChanged: (value){
                      c.fileList[c.selectIndex.value].enableClip = value ?? false;
                      if(!c.fileList[c.selectIndex.value].enableClip){
                        c.fileList[c.selectIndex.value].clipStart = null;
                        c.fileList[c.selectIndex.value].clipEnd = null;
                      }else{
                        c.fileList[c.selectIndex.value].clipStart = "00:00:00";
                        c.fileList[c.selectIndex.value].clipEnd = "00:00:10";
                      }
                      c.fileList.refresh();
                    },
                    content: Text('启用截取', style: GoogleFonts.notoSansSc(),),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: 130,
                    child: TextBox(
                      controller: TextEditingController(text: c.fileList[c.selectIndex.value].clipStart ?? ""),
                      enabled: c.fileList[c.selectIndex.value].enableClip,
                      placeholder: "开始时间 (hh:mm:ss)",
                      style: GoogleFonts.notoSansSc(
                        fontSize: 14
                      ),
                      onChanged: (val){
                        c.fileList[c.selectIndex.value].clipStart=val;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      "~",
                      style: GoogleFonts.notoSansSc(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  SizedBox(
                    width: 130,
                    child: TextBox(
                      controller: TextEditingController(text: c.fileList[c.selectIndex.value].clipEnd ?? ""),
                      enabled: c.fileList[c.selectIndex.value].enableClip,
                      placeholder: "结束时间 (hh:mm:ss)",
                      style: GoogleFonts.notoSansSc(
                        fontSize: 14
                      ),
                      onChanged: (val){
                        c.fileList[c.selectIndex.value].clipEnd=val;
                      },
                    ),
                  ),
                ],
              ),
              c.fileList[c.selectIndex.value].type==Types.video && c.fileList[c.selectIndex.value].outType==Types.video ? const SizedBox(height: 10,) : Container(),
              c.fileList[c.selectIndex.value].type==Types.video && c.fileList[c.selectIndex.value].outType==Types.video ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '大小',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  Checkbox(
                    checked: (c.fileList[c.selectIndex.value].videoEncoders!=VideoEncoders.copy && (c.fileList[c.selectIndex.value].width!=null || c.fileList[c.selectIndex.value].height!=null)), 
                    onChanged: c.fileList[c.selectIndex.value].videoEncoders==VideoEncoders.copy ? null : (val){
                      if(val!=null){
                        if(val==false){
                          c.fileList[c.selectIndex.value].height=null;
                          c.fileList[c.selectIndex.value].width=null;
                        }else{
                          c.fileList[c.selectIndex.value].height=1080;
                          c.fileList[c.selectIndex.value].width=1920;
                        }
                        c.fileList.refresh();
                      }
                    },
                    content: Text('指定大小', style: GoogleFonts.notoSansSc(),),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: 130,
                    child: NumberBox(
                      value: c.fileList[c.selectIndex.value].width ?? 0, 
                      mode: SpinButtonPlacementMode.inline,
                      clearButton: false,
                      onChanged: c.fileList[c.selectIndex.value].width==null ? null : (val){
                        if(val!=null){
                          int width=val as int;
                          c.fileList[c.selectIndex.value].width=width;
                          c.fileList.refresh();
                        }
                      }
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: FaIcon(FontAwesomeIcons.xmark),
                  ),
                  SizedBox(
                    width: 130,
                    child: NumberBox(
                      value: c.fileList[c.selectIndex.value].height ?? 0, 
                      mode: SpinButtonPlacementMode.inline,
                      clearButton: false,
                      onChanged: c.fileList[c.selectIndex.value].height==null ? null : (val){
                        if(val!=null){
                          int width=val as int;
                          c.fileList[c.selectIndex.value].height=width;
                          c.fileList.refresh();
                        }
                      }
                    ),
                  ),
                ],
              ) : Container(),
              c.fileList[c.selectIndex.value].type==Types.video && c.fileList[c.selectIndex.value].outType==Types.video ? const SizedBox(height: 10,) : Container(),
              c.fileList[c.selectIndex.value].type==Types.video && c.fileList[c.selectIndex.value].outType==Types.video ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '音频',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  Checkbox(
                    checked: c.fileList[c.selectIndex.value].audioEncoders!=AudioEncoders.copy && c.fileList[c.selectIndex.value].audioVolume!=null, 
                    onChanged: c.fileList[c.selectIndex.value].audioEncoders==AudioEncoders.copy ? null : (val){
                      if(val!=null){
                        if(val==false){
                          c.fileList[c.selectIndex.value].audioVolume=null;
                        }else{
                          c.fileList[c.selectIndex.value].audioVolume=1;
                        }
                        c.fileList.refresh();
                      }
                    },
                    content: Text('指定增益', style: GoogleFonts.notoSansSc(),),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: 130,
                    child: NumberBox(
                      value: c.fileList[c.selectIndex.value].audioVolume ?? 1, 
                      mode: SpinButtonPlacementMode.inline,
                      clearButton: false,
                      onChanged: c.fileList[c.selectIndex.value].audioVolume==null ? null : (val){
                        if(val!=null){
                          int volume=val as int;
                          c.fileList[c.selectIndex.value].audioVolume=volume;
                          c.fileList.refresh();
                        }
                      }
                    ),
                  )
                ],
              ) : Container(),
              c.fileList[c.selectIndex.value].type==Types.video && c.fileList[c.selectIndex.value].outType==Types.video ? const SizedBox(height: 10,) : Container(),
              c.fileList[c.selectIndex.value].type==Types.video && c.fileList[c.selectIndex.value].outType==Types.video ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '视频轨道',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: NumberBox(
                      clearButton: false,
                      min: 0,
                      mode: SpinButtonPlacementMode.inline,
                      value: c.fileList[c.selectIndex.value].videoTrack, 
                      onChanged: c.fileList[c.selectIndex.value].videoEncoders==VideoEncoders.copy ? null : (val){
                        val=val as int;
                        if(val>=0){
                          c.fileList[c.selectIndex.value].videoTrack=val;
                          c.fileList.refresh();
                        }
                      }
                    ),
                  )
                ]
              ) : Container(),
              c.fileList[c.selectIndex.value].type==Types.video && c.fileList[c.selectIndex.value].outType==Types.video ? const SizedBox(height: 10,) : Container(),
              c.fileList[c.selectIndex.value].type==Types.video && c.fileList[c.selectIndex.value].outType==Types.video ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '音频轨道',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: NumberBox(
                      clearButton: false,
                      min: 0,
                      mode: SpinButtonPlacementMode.inline,
                      value: c.fileList[c.selectIndex.value].audioTrack, 
                      onChanged: c.fileList[c.selectIndex.value].videoEncoders==VideoEncoders.copy ? null : (val){
                        val=val as int;
                        if(val>=0){
                          c.fileList[c.selectIndex.value].audioTrack=val;
                          c.fileList.refresh();
                        }
                      }
                    ),
                  )
                ]
              ) : Container(),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '声道',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: NumberBox(
                      clearButton: false,
                      mode: SpinButtonPlacementMode.inline,
                      value: c.fileList[c.selectIndex.value].channel,
                      min: 1,
                      max: 6,
                      onChanged: c.fileList[c.selectIndex.value].audioEncoders==AudioEncoders.copy ? null : (val){
                        val=val as int;
                        c.fileList[c.selectIndex.value].channel=val;
                        c.fileList.refresh();
                      }
                    ),
                  )
                ]
              ),
              const SizedBox(height: 10,),
              c.fileList[c.selectIndex.value].type==Types.video  && c.fileList[c.selectIndex.value].outType==Types.video ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '字幕',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  ComboBox(
                    value: c.fileList[c.selectIndex.value].subTitleType,
                    items: [
                      ComboBoxItem(
                        value: SubTitleType.none,
                        child: Text('无', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: SubTitleType.embed,
                        child: Text('内嵌字幕', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: SubTitleType.file,
                        child: Text('外部字幕', style: GoogleFonts.notoSansSc(),),
                      )
                    ],
                    onChanged: c.fileList[c.selectIndex.value].videoEncoders==VideoEncoders.copy ? null : (value) async {
                      value=value as SubTitleType?;

                      if(value==SubTitleType.embed){
                        int? line=await showEmbedSubDialog(context);
                        if(line==null){
                          value=SubTitleType.none;
                        }else{
                          c.fileList[c.selectIndex.value].subtitleTrack=line;
                        }
                      }else if(value==SubTitleType.file){
                        String? path=await showSrtDialog(context);
                        if(path==null){
                          value=SubTitleType.none;
                        }else{
                          c.fileList[c.selectIndex.value].subTitleFile=path;
                        }
                      }

                      if(value!=null){
                        c.fileList[c.selectIndex.value].subTitleType=value;
                        c.fileList.refresh();
                      }
                    },
                  ),
                  const SizedBox(width: 10,),
                  if(c.fileList[c.selectIndex.value].subTitleType!=SubTitleType.none) Expanded(
                    child: Text(
                      c.fileList[c.selectIndex.value].subTitleType==SubTitleType.embed ? "字幕轨道: ${c.fileList[c.selectIndex.value].subtitleTrack.toString()}" 
                      : "字幕文件: ${c.fileList[c.selectIndex.value].subTitleFile}",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansSc(),
                    ),
                  )
                ]
              ) : Container(),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      '输出名称',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  Expanded(
                    child: TextBox(
                      controller: nameController,
                      onChanged: (val){
                        c.fileList[c.selectIndex.value].outputName=val;
                      },
                      style: GoogleFonts.notoSansSc(
                        fontSize: 14
                      ),
                    )
                  ),
                  const SizedBox(width: 2,),
                  Text(".${c.fileList[c.selectIndex.value].format.name}", style: GoogleFonts.notoSansSc())
                ]
              ),
            ],
          ) : Container(),
        ),
      ),
    );
  }
}