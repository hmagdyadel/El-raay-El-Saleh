import '../models/served.dart';
import '../pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import '../controllers/served_controller.dart';

class UpdatePerson extends StatefulWidget {
  const UpdatePerson({Key? key, required this.servedController})
      : super(key: key);
  final Served? servedController;

  @override
  _UpdatePersonState createState() => _UpdatePersonState();
}

class _UpdatePersonState extends State<UpdatePerson> {
  final ServedController _servedController = Get.put(ServedController());
  String? _name = '';
  String? _age = '';
  String? _address = '';
  String? _phone = '';
  String? _law = '';
  DateTime _selectedDate1 = DateTime.now();
  DateTime _selectedDate2 = DateTime.now();

  @override
  void initState() {
    setState(() {
      _name = widget.servedController?.name!;
      _age = widget.servedController?.age.toString();
      _address = widget.servedController?.address;
      _phone = widget.servedController?.phone;
      _law = widget.servedController?.law;
      List date = widget.servedController!.recognitionDate!.split('/');
      String month = date[0];
      String day = date[1];
      if (month.length == 1) {
        month = '0' + month;
      }
      if (day.length == 1) {
        day = '0' + day;
      }
      String recognition = date[2] + '-' + month + '-' + day;
      _selectedDate1 = DateTime.parse(recognition);
      date = widget.servedController!.intakeDate!.split('/');
      month = date[0];
      day = date[1];
      if (month.length == 1) {
        month = '0' + month;
      }
      if (day.length == 1) {
        day = '0' + day;
      }
      String intake = date[2] + '-' + month + '-' + day;
      _selectedDate2 = DateTime.parse(intake);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _servedController.getAllServed();
        Get.to(() => const HomePage());
        return Future(() => true);
      },
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          appBar: _appBar(),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTextFormField(widget.servedController?.name,
                      TextInputType.name, 'ادخل الإسم', 'الإسم', 1),
                  const SizedBox(height: 15),
                  _buildTextFormField(widget.servedController?.age.toString(),
                      TextInputType.number, 'ادخل العمر', 'العمر', 2),
                  const SizedBox(height: 15),
                  _buildTextFormField(widget.servedController?.address,
                      TextInputType.text, 'ادخل العنوان', 'العنوان', 3),
                  const SizedBox(height: 15),
                  _buildTextFormField('0${widget.servedController?.phone}',
                      TextInputType.phone, 'ادخل رقم التليفون', 'التليفون', 4),
                  const SizedBox(height: 15),
                  _buildTextFormField(
                      widget.servedController?.law,
                      TextInputType.text,
                      'ادخل القانون الروحي',
                      'القانون الروحي',
                      5),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text(
                                'تاريخ اخر إعتراف',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(width: 25),
                            Expanded(
                                child: Text(
                              'تاريخ اخر تناول',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _buildExpandedDate(
                              DateFormat.yMd().format(_selectedDate1), 1),
                          const SizedBox(width: 8),
                          _buildExpandedDate(
                              DateFormat.yMd().format(_selectedDate2), 2),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: GestureDetector(
                      onTap: _validation,
                      child: Container(
                        alignment: Alignment.center,
                        width: 140,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.teal),
                        child: const Text(
                          'تعديل مخدوم',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildExpandedDate(String text, int n) {
    return Expanded(
        child: InkWell(
      onTap: () {
        getDateFromUser(n);
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1)),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(width: 20),
            const Icon(
              Icons.calendar_today_outlined,
              color: Colors.grey,
              size: 25,
            )
          ],
        ),
      ),
    ));
  }

  getDateFromUser(int n) async {
    DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: n == 1 ? _selectedDate1 : _selectedDate2,
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    );
    if (_pickedDate != null)
      setState(() {
        n == 1 ? _selectedDate1 = _pickedDate : _selectedDate2 = _pickedDate;
      });
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.teal,
      leading: Container(),
      actions: [
        IconButton(
          onPressed: () => Get.to(() => const HomePage()),
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
      ],
      centerTitle: true,
      title: const Text(
        'تعديل بيانات مخدوم',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  _validation() {
    if (_name!.isNotEmpty &&
        _age!.isNotEmpty &&
        _address!.isNotEmpty &&
        _phone!.isNotEmpty &&
        _law!.isNotEmpty) {
      _addServedToDb();
      Get.to(() => const HomePage());
    } else if (_name!.isEmpty) {
      showSnackBar('الإسم', 'من فضلك ادخل الإسم');
    } else if (_age!.isEmpty) {
      showSnackBar('العمر', 'من فضلك ادخل العمر');
    } else if (_address!.isEmpty) {
      showSnackBar('العنوان', 'من فضلك ادخل العنوان');
    } else if (_phone!.isEmpty) {
      showSnackBar('التليفون', 'من فضلك ادخل التليفون');
    } else if (_law!.isEmpty) {
      showSnackBar('القانون الروحي', 'من فضلك ادخل القانون الروحي');
    }
  }

  showSnackBar(String title, String details) {
    Get.snackbar(
      title,
      details,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Colors.amber[500],
        size: 60,
      ),
    );
  }

  _buildTextFormField(String? initial, TextInputType type, String hint,
      String label, int attribute) {
    return TextFormField(
      initialValue: initial,
      onFieldSubmitted: (value) => setState(() {
        print(attribute);
        print(value);
        attribute == 1
            ? _name = value
            : attribute == 2
                ? _age = value
                : attribute == 3
                    ? _address = value
                    : attribute == 4
                        ? _phone = value
                        : _law = value;
      }),
      keyboardType: type,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hint,
          labelText: label,
          labelStyle:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
    );
  }

  _addServedToDb() async {
    await _servedController.updateServed(
      widget.servedController!.id!,
      _name!,
      _age!,
      _phone!,
      _address!,
      _law!,
      DateFormat.yMd().format(_selectedDate2),
      DateFormat.yMd().format(_selectedDate1),
    );
    await _servedController.getAllServed();
  }
}
