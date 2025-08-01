import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:google_fonts/google_fonts.dart';

Future<String?> showSrtDialog(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['ass'],
  );
  if (result != null) {
    return result.files.single.path!;
  }
  return null;
}

Future<int?> showEmbedSubDialog(BuildContext context) async {
  int? subLine=0;
  await showDialog(
    context: context, 
    builder: (context)=>ContentDialog(
      title: Text('字幕轨道', style: GoogleFonts.notoSansSc(),),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 30,
            child: Row(
              children: [
                Text('字幕轨道', style: GoogleFonts.notoSansSc(),),
                const SizedBox(width: 10,),
                Expanded(
                  child: NumberBox(
                    min: 0,
                    value: subLine, 
                    onChanged: (val){
                      setState((){
                        subLine=val;
                      });
                    }
                  )
                )
              ],
            ),
          );
        }
      ),
      actions: [
        Button(
          child: Text("取消", style: GoogleFonts.notoSansSc(),), 
          onPressed: (){
            subLine=null;
            Navigator.pop(context);
          }
        ),
        FilledButton(
          child: Text("完成", style: GoogleFonts.notoSansSc(),), 
          onPressed: ()=>Navigator.pop(context)
        )
      ],
    )
  );
  return subLine;
}