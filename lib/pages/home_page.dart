import '../controllers/served_controller.dart';

import '../pages/add_person.dart';
import '../pages/divide_served.dart';
import '../pages/edit_screen.dart';
import '../pages/served_element.dart';
import '../pages/splash_page.dart';
import '../widgets/list_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../models/served.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ServedController _servedController = Get.put(ServedController());
  bool icon = false;
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _servedController.getAllServed();
    _servedController.servedList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: _appBar(),
        body: Column(
          children: [
            _dividePeople(),

            const Divider(color: Colors.grey),

            _showNames(),
            //_showServed(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Get.to(() => const AddPerson());
            _servedController.getAllServed();
          },
          child: const Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _servedController.getAllServed();
    _dividePeople();
  }

  _showNames() {
    return Expanded(
      child: Obx(
        () {
          if (_servedController.servedList.isEmpty) {
            return const Center(
              child: Text(
                'لا يوجد مخدومين',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: buildListView(_servedController.servedList),
            );
          }
        },
      ),
    );
  }

  buildListView(List list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        var served = list[index];
        return Dismissible(
          secondaryBackground: buildSwipeActionLeft(),
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

  _dividePeople() {
    // print(MediaQuery.of(context).size.width);//360
    // print(MediaQuery.of(context).size.height);//756
    _servedController.getAllServed();

    return Container(
        margin: const EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height / 15.12,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => const DivideServed(type: 'green'));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_box_outlined,
                      color: Colors.green,
                      size: 40,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      greenItem(0, _servedController.servedList).toString(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => const DivideServed(type: 'amber'));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_alert,
                      color: Colors.amber,
                      size: 40,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      amberItem(1, _servedController.servedList).toString(),
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => const DivideServed(type: 'red'));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 40,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      redItem(2, _servedController.servedList).toString(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.teal,
      centerTitle: true,
      leading: Container(),
      title: const Text(
        'بيانات المخدومين',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  int greenItem(int element, List list) {
    int countNumber = 0;
    for (int i = 0; i < list.length; i++) {
      if (element == 0 &&
          _selectedDate
                  .difference(DateFormat.yMd().parse(list[i].recognitionDate!))
                  .inDays <
              20) {
        setState(() {
          countNumber = countNumber + 1;
        });
      }
    }
    return countNumber;
  }

  int amberItem(int element, List list) {
    int countNumber = 0;
    for (int i = 0; i < list.length; i++) {
      if (element == 1 &&
          _selectedDate
                  .difference(DateFormat.yMd().parse(list[i].recognitionDate!))
                  .inDays <
              30 &&
          _selectedDate
                  .difference(DateFormat.yMd().parse(list[i].recognitionDate!))
                  .inDays >
              20) {
        setState(() {
          countNumber = countNumber + 1;
        });
      }
    }
    return countNumber;
  }

  int redItem(int element, List list) {
    int countNumber = 0;
    for (int i = 0; i < list.length; i++) {
      if (element == 2 &&
          _selectedDate
                  .difference(DateFormat.yMd().parse(list[i].recognitionDate!))
                  .inDays >
              30) {
        setState(() {
          countNumber = countNumber + 1;
        });
      }
    }
    return countNumber;
  }

  Widget buildSwipeActionLeft() {
    return Container(
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
    );
  }
}
