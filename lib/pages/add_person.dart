import '../controllers/served_controller.dart';
import '../models/served.dart';
import '../widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddPerson extends StatefulWidget {
  const AddPerson({Key? key}) : super(key: key);

  @override
  _AddPersonState createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  final ServedController _servedController = Get.put(ServedController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _lawController = TextEditingController();
  DateTime _selectedDate1 = DateTime.now();
  DateTime _selectedDate2 = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              InputField(
                title: 'الإسم',
                hint: 'ادخل الإسم',
                controller: _nameController,
                keyType: 1,
              ),
              InputField(
                title: 'العمر',
                hint: 'ادخل العمر',
                controller: _ageController,
                keyType: 2,
              ),
              const SizedBox(height: 5),
              InputField(
                title: 'العنوان',
                hint: 'ادخل العنوان',
                controller: _addressController,
                keyType: 1,
              ),
              const SizedBox(height: 5),
              InputField(
                title: 'التليفون',
                hint: 'ادخل رقم التليفون',
                controller: _phoneController,
                keyType: 2,
              ),
              const SizedBox(height: 5),
              InputField(
                title: 'القانون الروحي',
                hint: 'ادخل القانون الروحي',
                controller: _lawController,
                keyType: 3,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'ميعاد أخر تناول',
                      hint: DateFormat.yMd().format(_selectedDate1),
                      keyType: 1,
                      widget: IconButton(
                        onPressed: () => getDateFromUser(1),
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: InputField(
                      title: 'ميعاد أخر إعتراف',
                      keyType: 1,
                      hint: DateFormat.yMd().format(_selectedDate2),
                      widget: IconButton(
                        onPressed: () => getDateFromUser(2),
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
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
                      'إضافة مخدوم',
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
    );
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
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_forward_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
      ],
      centerTitle: true,
      title: const Text(
        'إضافة مخدوم',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      ),
    );
  }

  _validation() {
    if (_nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _lawController.text.isNotEmpty) {
      _addServedToDb();
      Get.back();
    } else if (_nameController.text.isEmpty) {
      showSnackBar('الإسم', 'من فضلك ادخل الإسم');
    } else if (_ageController.text.isEmpty) {
      showSnackBar('العمر', 'من فضلك ادخل العمر');
    } else if (_addressController.text.isEmpty) {
      showSnackBar('العنوان', 'من فضلك ادخل العنوان');
    } else if (_phoneController.text.isEmpty) {
      showSnackBar('التليفون', 'من فضلك ادخل التليفون');
    } else if (_lawController.text.isEmpty) {
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

  _addServedToDb() async {
    int value = await _servedController.addServed(
      served: Served(
        name: _nameController.text,
        age: int.tryParse(_ageController.text),
        address: _addressController.text,
        phone: _phoneController.text.toString(),
        law: _lawController.text,
        intakeDate: DateFormat.yMd().format(_selectedDate1),
        recognitionDate: DateFormat.yMd().format(_selectedDate2),
      ),
    );
    _servedController.getAllServed();
    print(value);
  }
}
