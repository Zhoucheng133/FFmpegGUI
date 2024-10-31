import 'package:get/get.dart';
class Controller extends GetxController{
  RxBool running=false.obs;
  RxList log=[].obs;
  RxString command="".obs;
}