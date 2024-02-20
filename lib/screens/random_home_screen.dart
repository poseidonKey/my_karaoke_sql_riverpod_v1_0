import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/components/number_row.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/random_settings_screen.dart';

class RandomHomeScreen extends StatefulWidget {
  const RandomHomeScreen({Key? key}) : super(key: key);

  @override
  _RandomHomeScreenState createState() => _RandomHomeScreenState();
}

class _RandomHomeScreenState extends State<RandomHomeScreen> {
  int maxNumber = 1000;
  List<int> randomNumbers = [
    123,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBar(
        title: const Text('무작위 번호에 도전!!'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                onPressed: onSettingsPop,
              ),
              _Body(
                randomNumbers: randomNumbers,
              ),
              _Footer(
                onPressed: onRandomNumberGenerate,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSettingsPop() async {
    // list - add
    // [HomeScreen(), SettingsScreen()]
    final int? result = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return RandomSettingsScreen(
            maxNumber: maxNumber,
          );
        },
      ),
    );

    if (result != null) {
      setState(() {
        maxNumber = result;
      });
    }
  }

  void onRandomNumberGenerate() {
    final rand = Random();

    final Set<int> newNumbers = {};

    while (newNumbers.length != 1) {
      final number = rand.nextInt(maxNumber);

      newNumbers.add(number);
    }

    setState(() {
      randomNumbers = newNumbers.toList();
    });
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onPressed;

  const _Header({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '랜덤숫자 생성기',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.settings,
            color: RED_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final List<int> randomNumbers;

  const _Body({
    required this.randomNumbers,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: randomNumbers
              .asMap()
              .entries
              .map(
                (x) => Padding(
                  padding:
                      EdgeInsets.only(left: 40, bottom: x.key == 2 ? 0 : 16.0),
                  child: NumberRow(
                    number: x.value,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onPressed;

  const _Footer({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: RED_COLOR,
        ),
        onPressed: onPressed,
        child: const Text(
          '생성하기!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
