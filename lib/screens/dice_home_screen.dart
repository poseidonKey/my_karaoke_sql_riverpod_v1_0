import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';

class DiceHomeScreen extends StatelessWidget {
  final int number;
  const DiceHomeScreen({
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset('assets/img/$number.png'),
        ),
        const SizedBox(
          height: 32,
        ),
        Text(
          '행운의 숫자',
          style: TextStyle(
            color: secondaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          number.toString(),
          style: const TextStyle(
            color: primaryColor,
            fontSize: 60,
            fontWeight: FontWeight.w200,
          ),
        )
      ],
    );
  }
}
