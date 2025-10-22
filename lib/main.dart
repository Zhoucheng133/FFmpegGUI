import 'package:ffmpeg_gui/main_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';
final FlutterLocalNotificationsPlugin notifications =FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 680),
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
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      windowManager.focus();
    },
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: FluentThemeData(
        accentColor: Colors.green,
      ),
      home: const MainWindow()
    );
  }
}
