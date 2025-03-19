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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          c.fileList[c.selectIndex.value].encoder=Encoders.libx264;
                        }else if(c.fileList[c.selectIndex.value].outType==Types.audio){
                          c.fileList[c.selectIndex.value].format=Formats.mp3;
                          c.fileList[c.selectIndex.value].encoder=Encoders.libmp3lame;
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
                  ComboBox(
                    value: c.fileList[c.selectIndex.value].encoder,
                    items: c.fileList[c.selectIndex.value].outType==Types.video ?  [
                      ComboBoxItem(
                        value: Encoders.libx264,
                        child: Text('libx264', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.libx265,
                        child: Text('libx265', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.libaomav1,
                        child: Text('libaom-av1', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.libxvid,
                        child: Text('libxvid', style: GoogleFonts.notoSansSc(),),
                      ),
                    ] : [
                      ComboBoxItem(
                        value: Encoders.aac,
                        child: Text('aac', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.libmp3lame,
                        child: Text('libmp3lame', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Encoders.flac,
                        child: Text('flac', style: GoogleFonts.notoSansSc(),),
                      )
                    ],
                    onChanged: (value){
                      if(value!=null){
                        c.fileList[c.selectIndex.value].encoder=value;
                        if(c.fileList[c.selectIndex.value].encoder==Encoders.aac){
                          c.fileList[c.selectIndex.value].format=Formats.m4a;
                        }else if(c.fileList[c.selectIndex.value].encoder==Encoders.flac){
                          c.fileList[c.selectIndex.value].format=Formats.flac;
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
                        enabled: c.fileList[c.selectIndex.value].encoder!=Encoders.libaomav1,
                        child: Text('flv', style: GoogleFonts.notoSansSc(),),
                      ),
                    ] : [
                      ComboBoxItem(
                        value: Formats.mp3,
                        enabled: c.fileList[c.selectIndex.value].encoder!=Encoders.aac && c.fileList[c.selectIndex.value].encoder!=Encoders.flac,
                        child: Text('mp3', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.aac,
                        enabled: c.fileList[c.selectIndex.value].encoder!=Encoders.flac && c.fileList[c.selectIndex.value].encoder!=Encoders.libmp3lame,
                        child: Text('aac', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.wav,
                        enabled: c.fileList[c.selectIndex.value].encoder!=Encoders.aac && c.fileList[c.selectIndex.value].encoder!=Encoders.flac,
                        child: Text('wav', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.m4a,
                        enabled: c.fileList[c.selectIndex.value].encoder!=Encoders.flac && c.fileList[c.selectIndex.value].encoder!=Encoders.libmp3lame,
                        child: Text('m4a', style: GoogleFonts.notoSansSc(),),
                      ),
                      ComboBoxItem(
                        value: Formats.flac,
                        enabled: c.fileList[c.selectIndex.value].encoder==Encoders.flac,
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
                    checked: (c.fileList[c.selectIndex.value].width!=null || c.fileList[c.selectIndex.value].height!=null), 
                    onChanged: (val){
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
                      onChanged: (val){
                        if(val!=null && val>=0){
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
                      onChanged: (val){
                        if(val!=null && val>=0){
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
                      onChanged: (val){
                        if(val!=null){
                          c.fileList[c.selectIndex.value].channel=val;
                          c.fileList.refresh();
                        }
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
                      '字幕轨道',
                      style: GoogleFonts.notoSansSc(),
                    ),
                  ),
                  Checkbox(
                    checked: c.fileList[c.selectIndex.value].subtitleLine!=null, 
                    onChanged: (val){
                      if(val!=null){
                        if(val==false){
                          c.fileList[c.selectIndex.value].subtitleLine=null;
                        }else{
                          c.fileList[c.selectIndex.value].subtitleLine=0;
                        }
                        c.fileList.refresh();
                      }
                    },
                    content: Text('使用字幕', style: GoogleFonts.notoSansSc(),),
                  ),
                  const SizedBox(width: 10,),
                  SizedBox(
                    width: 200,
                    child: c.fileList[c.selectIndex.value].subtitleLine==null ? const NumberBox(
                      clearButton: false,
                      mode: SpinButtonPlacementMode.inline,
                      value: 0,
                      onChanged: null,
                    ) : NumberBox(
                      clearButton: false,
                      mode: SpinButtonPlacementMode.inline,
                      value: c.fileList[c.selectIndex.value].subtitleLine,
                      min: 0,
                      onChanged: (val){
                        if(val!=null){
                          c.fileList[c.selectIndex.value].subtitleLine=val;
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
                    )
                  ),
                  const SizedBox(width: 2,),
                  Text(".${c.fileList[c.selectIndex.value].format.name}")
                ]
              ),
              Expanded(child: Container()),
            ],
          ) : Container(),
        ),
      ),
    );
  }
}