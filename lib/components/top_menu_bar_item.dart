import 'package:flutter/material.dart';

class TopMenuBarItem extends StatefulWidget {

  final String title;
  final IconData icon;
  final VoidCallback func;
  final bool enable;

  const TopMenuBarItem({super.key, required this.title, required this.icon, required this.func, required this.enable});

  @override
  State<TopMenuBarItem> createState() => _TopMenuBarItemState();
}

class _TopMenuBarItemState extends State<TopMenuBarItem> {

  bool hover=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MouseRegion(
        onEnter: (_){
          if(widget.enable){
            setState(() {
              hover=true;
            });
          }
        },
        onExit: (_){
          setState(() {
            hover=false;
          });
        },
        cursor: widget.enable ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: hover ? const Color.fromARGB(255, 221, 247, 223) : const Color.fromARGB(0, 221, 247, 223),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 20,),
                const SizedBox(width: 5,),
                Text(widget.title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}