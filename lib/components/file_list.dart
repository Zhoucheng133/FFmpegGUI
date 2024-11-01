// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ffmpeg_gui/components/list_menu.dart';
import 'package:flutter/material.dart';

class FileList extends StatefulWidget {
  const FileList({super.key});

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          ListMenu()
        ],
      ),
    );
  }
}