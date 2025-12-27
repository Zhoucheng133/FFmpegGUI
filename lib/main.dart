import 'package:ffmpeg_gui/controllers/controller.dart';
import 'package:ffmpeg_gui/controllers/theme_controller.dart';
import 'package:ffmpeg_gui/lang/en_us.dart';
import 'package:ffmpeg_gui/lang/zh_cn.dart';
import 'package:ffmpeg_gui/main_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
final FlutterLocalNotificationsPlugin notifications =FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(850, 680),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: 'FFmpeg GUI'
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setResizable(false);
  });

  final controller=Get.put(Controller());
  Get.put(ThemeController());
  await controller.init();

  const initSettings = InitializationSettings(
    macOS: DarwinInitializationSettings(),
    windows: WindowsInitializationSettings(
      appName: 'FFmpeg GUI', 
      appUserModelId: 'zhouc.ffmpeg_gui', 
      guid: 'D840F2EA-8D01-4B0E-85C1-CFC39AC472AE'
    ),
  );

  await notifications.initialize(
    initSettings,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
  };
}

class _MainAppState extends State<MainApp> {

  final controller=Get.find<Controller>();
  final ThemeController themeController=Get.find();

  @override
  Widget build(BuildContext context) {

    final brightness = MediaQuery.of(context).platformBrightness;
    themeController.darkModeHandler(brightness==Brightness.dark);

    return Obx(
      () => GetMaterialApp(
        supportedLocales: supportedLocales.map((item)=>item.locale).toList(),
        fallbackLocale: Locale('en', 'US'),
        translations: MainTranslations(),
        locale: controller.lang.value.locale,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        theme: ThemeData(
          brightness: brightness,
          fontFamily: 'Noto', 
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: brightness,
          ),
          textTheme: brightness==Brightness.dark ? ThemeData.dark().textTheme.apply(
              fontFamily: 'Noto',
              bodyColor: Colors.white,
              displayColor: Colors.white,
          ) : ThemeData.light().textTheme.apply(
              fontFamily: 'Noto',
          ),
        ),
        home: Scaffold(
          body: const MainWindow(),
        )
      ),
    );
  }
}
