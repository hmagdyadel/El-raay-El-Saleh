import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListElement extends StatefulWidget {
  const ListElement(
      {Key? key, required this.name, required this.recognitionDate})
      : super(key: key);
  final String? name;
  final String? recognitionDate;

  @override
  _ListElementState createState() => _ListElementState();
}

class _ListElementState extends State<ListElement> {
  final DateTime _selectedDate = DateTime.now();
  int icon = 0;

  @override
  void initState() {
    specifyIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      height: 50,
      decoration: BoxDecoration(
        color: icon == 0
            ? Colors.white
            : icon == 1
                ? Colors.amber
                : Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.name!,
            style: const TextStyle(
              fontSize: 25,
            ),
          ),
          Icon(
            icon == 0
                ? Icons.check_box_outlined
                : icon == 1
                    ? Icons.add_alert
                    : Icons.warning_amber_rounded,
            color: icon == 0
                ? Colors.green.withOpacity(0.5)
                : Colors.white.withOpacity(0.5),
            size: 40,
          ),
        ],
      ),
    );
  }

  specifyIcon() {
    if (_selectedDate
            .difference(DateFormat.yMd().parse(widget.recognitionDate!))
            .inDays <
        20) {
      setState(() {
        icon = 0;
      });
    } else if (_selectedDate
                .difference(DateFormat.yMd().parse(widget.recognitionDate!))
                .inDays <
            30 &&
        _selectedDate
                .difference(DateFormat.yMd().parse(widget.recognitionDate!))
                .inDays >
            20) {
      setState(() {
        icon = 1;
      });
    } else {
      setState(() {
        icon = 2;
      });
    }
  }


}
