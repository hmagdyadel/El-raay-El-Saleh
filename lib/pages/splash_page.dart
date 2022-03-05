import '../pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/served_controller.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLoading = false;
  final ServedController _servedController = Get.put(ServedController());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = true;
      });
      Get.to(() => const HomePage());
    });
    _servedController.getAllServed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Image.asset(
          'assets/el_raee.jpeg',
          width: screenHeight,
          height: screenHeight,
          fit: BoxFit.fill,
        ),
        isLoading == true
            ? Container()
            : Positioned(
                child: const CircularProgressIndicator(),
                left: (screenWidth / 2) - 20,
                bottom: screenHeight / 4,
              )
      ],
    );
  }
}
