import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/dice_home_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/settings_screen.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  late TabController controller;
  double threshold = 2.7;
  int number = 1;
  ShakeDetector? shakeDetector;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(tabListener);
    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: onPhoneShake,
      shakeSlopTimeMS: 100,
      shakeThresholdGravity: threshold,
    );
  }

  void onPhoneShake() {
    final rand = Random();
    setState(() {
      number = rand.nextInt(5) + 1;
    });
  }

  void tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    shakeDetector!.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: renderChildren(),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [
      DiceHomeScreen(number: number),
      SettingsScreen(
          threshold: threshold, onThresholdChange: onThresholdChange),
    ];
  }

  void onThresholdChange(double value) {
    setState(() {
      threshold = value;
    });
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
        currentIndex: controller.index,
        onTap: (value) {
          setState(() {
            controller.animateTo(value);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edgesensor_high_outlined,
            ),
            label: '주사위',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: '설정',
          ),
        ]);
  }
}
