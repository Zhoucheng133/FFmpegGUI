import 'package:flutter/material.dart';

class DropdownListItem {
  final String label;
  final dynamic value;

  const DropdownListItem({required this.label, required this.value});
}

class Dropdown extends StatefulWidget {

  final dynamic value;
  final ValueChanged onChanged;
  final List<DropdownListItem> items;

  const Dropdown({super.key, required this.value, required this.onChanged, required this.items});

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.brightnessOf(context)==Brightness.dark ? Colors.grey[850]:Colors.white,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          borderRadius: BorderRadius.circular(5),
          icon: Padding(
            padding: .only(left: 5),
            child: Icon(Icons.arrow_drop_down),
          ),
          focusColor: Colors.transparent,
          isDense: true,
          dropdownColor: Theme.of(context).brightness==Brightness.dark ? Colors.grey[850]:Colors.white,
          padding: .symmetric(horizontal: 10, vertical: 8),
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).brightness==Brightness.dark ? Colors.white : Colors.black
          ),
          value: widget.value,
          items: widget.items.map((item)=>DropdownMenuItem(
            value: item.value,
            child: Text(item.label)
          )).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}