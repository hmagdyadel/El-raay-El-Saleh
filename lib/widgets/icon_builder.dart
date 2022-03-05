import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IconBuilder extends StatefulWidget {
  const IconBuilder({Key? key, required this.recognitionDate})
      : super(key: key);
  final String? recognitionDate;

  @override
  State<IconBuilder> createState() => _IconBuilderState();
}

class _IconBuilderState extends State<IconBuilder> {
  final DateTime _selectedDate = DateTime.now();
  int icon = 0;

  @override
  void initState() {
    specifyIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon == 0
          ? Icons.check_box_outlined
          : icon == 1
              ? Icons.add_alert
              : Icons.warning_amber_rounded,
      color: icon == 0
          ? Colors.green
          : icon == 1
              ? Colors.amber
              : Colors.red,
      size: 100,
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
