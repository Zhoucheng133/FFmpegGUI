import 'package:dropdown_button2/dropdown_button2.dart';
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
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        menuItemStyleData: MenuItemStyleData(
          height: 35,
        ),
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
    );
  }
}