import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/cover.png',
              fit: BoxFit.fill,
          ),
        ),
          Container(
            width: 350,
            child: Image.asset(
                'assets/images/solar.png',
                fit: BoxFit.contain
            ),
          ),
          Positioned(
            bottom: 30,
              width: 84,
              height: 40,
              child: Image.asset(
                'assets/images/logo_bt.png',
                fit: BoxFit.cover,
              ),
          )],
      ),
    );
  }
}
