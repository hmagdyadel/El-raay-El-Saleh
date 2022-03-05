import '../models/served.dart';
import '../pages/served_element.dart';
import '../pages/splash_page.dart';
import 'package:flutter/material.dart';

import '../controllers/served_controller.dart';
import 'package:get/get.dart';

import '../widgets/list_element.dart';
import 'edit_screen.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class DivideServed extends StatefulWidget {
  const DivideServed({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  _DivideServedState createState() => _DivideServedState();
}

class _DivideServedState extends State<DivideServed> {
  final ServedController _servedController = Get.put(ServedController());
  List<Served> servedList = [];
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    createList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.type == 'red'
                ? 'الاعتراف الاكثر من 30 يوم'
                : widget.type == 'amber'
                    ? 'الاعتراف مابين 20 -30 يوم'
                    : 'الاعتراف الاقل من 20 يوم',
            style: const TextStyle( fontSize: 20),
          ),
          leading: Container(),
          actions: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: buildListView(servedList),
        ),
      ),
    );
  }

  buildListView(List list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        var served = list[index];
        return Dismissible(
          secondaryBackground: Container(
            height: MediaQuery.of(context).size.height / 16.8,
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.red),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
          ),
          background: Container(
            height: MediaQuery.of(context).size.height / 16.8,
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.green),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 40,
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              _showMyDialog(
                  _servedController.servedList[index].name.toString(), served);
            } else
              Get.to(() => UpdatePerson(servedController: served));
          },
          key: UniqueKey(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    await Get.to(
                        () => ServedDetails(servedController: list[index]));
                  },
                  child: Ink(
                    child: ListElement(
                        name: served.name,
                        recognitionDate: served.recognitionDate),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _showMyDialog(String name, Served served) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'حذف',
            textDirection: ui.TextDirection.rtl,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'هل تريد حذف هذا المخدوم؟',
                  textDirection: ui.TextDirection.rtl,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  name,
                  textDirection: ui.TextDirection.rtl,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('حذف'),
              onPressed: () {
                setState(() {
                  _servedController.deleteServed(served);
                  Get.to(()=>const Splash());
                });


                Get.snackbar(
                  '',
                  '',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.black54,
                  colorText: Colors.white,
                  titleText: const Text(
                    'حذف',
                    textDirection: ui.TextDirection.rtl,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  messageText: const Text(
                    'تم حذف بيانات هذا المخدوم',
                    textDirection: ui.TextDirection.rtl,
                  ),
                );
              },
            ),
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                _servedController.getAllServed();
                Get.back();
              },
            ),
            Container(
              width: 120,
            ),
          ],
        );
      },
    );
  }
  createList() {
    if (widget.type == 'green') {
      for (int i = 0; i < _servedController.servedList.length; i++) {
        if (_selectedDate
                .difference(DateFormat.yMd()
                    .parse(_servedController.servedList[i].recognitionDate!))
                .inDays <
            20) {
          setState(() {
            servedList.add(_servedController.servedList[i]);
          });
        }
      }
    } else if (widget.type == 'amber') {
      for (int i = 0; i < _servedController.servedList.length; i++) {
        if (_selectedDate
                    .difference(DateFormat.yMd().parse(
                        _servedController.servedList[i].recognitionDate!))
                    .inDays <
                30 &&
            _selectedDate
                    .difference(DateFormat.yMd().parse(
                        _servedController.servedList[i].recognitionDate!))
                    .inDays >
                20) {
          setState(() {
            servedList.add(_servedController.servedList[i]);
          });
        }
      }
    } else {
      for (int i = 0; i < _servedController.servedList.length; i++) {
        if (_selectedDate
                .difference(DateFormat.yMd()
                    .parse(_servedController.servedList[i].recognitionDate!))
                .inDays >
            30) {
          setState(() {
            servedList.add(_servedController.servedList[i]);
          });
        }
      }
    }
  }
}
