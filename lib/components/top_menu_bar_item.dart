import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      onTap: ()=>widget.func(),
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
            color: hover ? const Color.fromARGB(255, 223, 240, 198) : const Color.fromARGB(0, 223, 240, 198),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon, size: 12, 
                  color: widget.enable ? Colors.grey[800] : Colors.grey[400],
                ),
                widget.title.isNotEmpty ? const SizedBox(width: 8,) : Container(),
                widget.title.isNotEmpty ? Text(
                  widget.title, 
                  style: GoogleFonts.notoSansSc(
                    color: widget.enable ? Colors.grey[800] : Colors.grey[400]
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}