import 'dart:io';

import 'package:ffmpeg_gui/components/config_panel.dart';
import 'package:ffmpeg_gui/components/header_buttons.dart';
import 'package:ffmpeg_gui/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

 @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  bool isMax=false;

  @override
  void onWindowMaximize(){
    setState(() {
      isMax=true;
    });
  }
  
  @override
  void onWindowUnmaximize(){
    setState(() {
      isMax=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
          child: Row(
            children: [
              Expanded(child: DragToMoveArea(child: Container())),
              if(Platform.isWindows) Row(
                children: [
                  WindowCaptionButton.minimize(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.minimize()
                  ),
                  isMax ? WindowCaptionButton.unmaximize(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.unmaximize()
                  ) : WindowCaptionButton.maximize(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.maximize()
                  ),  
                  WindowCaptionButton.close(
                    brightness: Theme.of(context).brightness,
                    onPressed: ()=>windowManager.close()
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: HeaderButtons(),
        ),
        Expanded(
          child: Row(
            children: [
              Container(width: 250,),
              Expanded(child: ConfigPanel()),
            ],
          )
        ),
        if(Platform.isMacOS) PlatformMenuBar(
          menus: [
            PlatformMenu(
              label: "FFmpeg GUI",
              menus: [
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "关于 FFmpeg GUI",
                      onSelected: ()=>showAbout(context)
                    )
                  ]
                ),
                PlatformMenuItemGroup(
                  members: [
                    PlatformMenuItem(
                      label: "设置",
                      shortcut: const SingleActivator(
                        LogicalKeyboardKey.comma,
                        meta: true,
                      ),
                      onSelected: (){
                        // TODO 设置
                      }
                    ),
                  ]
                ),
                const PlatformMenuItemGroup(
                  members: [
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.hide,
                    ),
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.quit,
                    ),
                  ]
                ),
              ]
            ),
            PlatformMenu(
              label: "编辑",
              menus: [
                PlatformMenuItem(
                  label: "拷贝",
                  onSelected: (){
                    final focusedContext = FocusManager.instance.primaryFocus?.context;
                    if (focusedContext != null) {
                      Actions.invoke(focusedContext, CopySelectionTextIntent.copy);
                    }
                  }
                ),
                PlatformMenuItem(
                  label: "粘贴",
                  onSelected: (){
                    final focusedContext = FocusManager.instance.primaryFocus?.context;
                    if (focusedContext != null) {
                      Actions.invoke(focusedContext, const PasteTextIntent(SelectionChangedCause.keyboard));
                    }
                  },
                ),
                PlatformMenuItem(
                  label: "全选",
                  onSelected: (){
                    final focusedContext = FocusManager.instance.primaryFocus?.context;
                    if (focusedContext != null) {
                      Actions.invoke(focusedContext, const SelectAllTextIntent(SelectionChangedCause.keyboard));
                    }
                  }
                )
              ]
            ),
            const PlatformMenu(
              label: "窗口", 
              menus: [
                PlatformMenuItemGroup(
                  members: [
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.minimizeWindow,
                    ),
                    PlatformProvidedMenuItem(
                      enabled: true,
                      type: PlatformProvidedMenuItemType.toggleFullScreen,
                    )
                  ]
                )
              ]
            )
          ]
        )
      ],
    );
  }
}