class Served {
  int? id;
  String? name;
  int? age;
  String? address;
  String? phone;
  String? law;
  String? recognitionDate;
  String? intakeDate;

  Served({
    this.id,
    this.name,
    this.age,
    this.phone,
    this.address,
    this.law,
    this.recognitionDate,
    this.intakeDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'phone': phone,
      'address': address,
      'law': law,
      'recognitionDate': recognitionDate,
      'intakeDate': intakeDate
    };
  }

  Served.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    age = map['age'];
    phone = map['phone'].toString();
    address = map['address'];
    law = map['law'];
    recognitionDate = map['recognitionDate'];
    intakeDate = map['intakeDate'];
  }
}
