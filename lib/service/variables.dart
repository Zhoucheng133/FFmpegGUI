import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:get/get.dart';

class Controller extends GetxController{
  RxBool running=false.obs;
  RxList log=[].obs;
  RxString command="".obs;

  var fileList=<TaskItem>[].obs;
  RxInt selectIndex=0.obs;
}