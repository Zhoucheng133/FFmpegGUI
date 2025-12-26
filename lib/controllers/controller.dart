import 'package:ffmpeg_gui/service/task_item.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  RxBool running = false.obs;
  RxList<String> log = RxList<String>([]);

  RxList<TaskItem> fileList=RxList<TaskItem>([]);
  RxInt selectIndex=0.obs;
  RxString output=''.obs;
  RxString ffmpeg=''.obs;

  RxBool useNotification=true.obs;
}