import '../db/db_helper.dart';
import '../models/served.dart';
import 'package:get/get.dart';

class ServedController extends GetxController {
  final RxList<Served> servedList = <Served>[].obs;

  Future<int> addServed({required Served served}) {
    return DBHelper.insert(served);
  }

  Future<void> getAllServed() async {
    final List<Map<String, dynamic>> served = await DBHelper.query();
    servedList.assignAll(served.map((data) => Served.fromJson(data)).toList());
  }

  void deleteServed(Served served) async {
    await DBHelper.delete(served);
    getAllServed();
  }

  void deleteAllServed(Served served) async {
    await DBHelper.deleteAll();
    getAllServed();
  }

  Future<int> updateServed(
    int id,
    String name,
    String age,
    String phone,
    String address,
    String law,
    String intakeDate,
    String recognitionDate,
  ) async {
    await DBHelper.update(
        id, name, age, phone, address, law, intakeDate, recognitionDate);

    getAllServed();
    return await DBHelper.update(
        id, name, age, phone, address, law, intakeDate, recognitionDate);
  }
}
