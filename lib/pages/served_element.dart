import '../pages/edit_screen.dart';
import 'package:flutter/material.dart';
import '../models/served.dart';
import '../widgets/icon_builder.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ServedDetails extends StatefulWidget {
  const ServedDetails({Key? key, required this.servedController})
      : super(key: key);
  final Served servedController;

  @override
  _ServedDetailsState createState() => _ServedDetailsState();
}

class _ServedDetailsState extends State<ServedDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'تفاصيل المخدوم',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () => Get.back(),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Get.to(() =>  UpdatePerson(servedController: widget.servedController,)),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Center(
                    child: IconBuilder(
                        recognitionDate:
                            widget.servedController.recognitionDate),
                  ),
                  const SizedBox(height: 15),
                  servedElement(
                      context, 'الإسم', widget.servedController.name!),
                  Divider(color: Colors.grey[700]),
                  servedElement(
                      context, 'العمر', widget.servedController.age.toString()),
                  Divider(color: Colors.grey[700]),
                  servedElement(context, 'التليفون',
                      '0' + widget.servedController.phone!),
                  Divider(color: Colors.grey[700]),
                  servedElement(
                      context, 'العنوان', widget.servedController.address!),
                  Divider(color: Colors.grey[700]),
                  servedElement(
                      context, 'القانون الروحي', widget.servedController.law!),
                  Divider(color: Colors.grey[700]),
                  servedElement(context, 'تاريخ اخر إعتراف',
                      widget.servedController.recognitionDate!),
                  Divider(color: Colors.grey[700]),
                  servedElement(context, 'تاريخ اخر تناول',
                      widget.servedController.intakeDate!),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          launch('tel://0${widget.servedController.phone}');
                        },
                        child: const Icon(
                          Icons.call,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          launch(
                              'https://api.whatsapp.com/send?phone=20${widget.servedController.phone}');
                        },
                        child: Image.asset(
                          'assets/whats.jpg',
                          width: 45,
                          height: 45,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Row servedElement(BuildContext context, String description, String element) {
  return Row(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width / 2.7,
        child: Text(
          description,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: SizedBox(
          height: 50,
          child: VerticalDivider(
            color: Colors.grey[700],
          ),
        ),
      ),
      Expanded(
        child: Text(
          element,
          style: const TextStyle(fontSize: 20),
        ),
      )
    ],
  );
}
