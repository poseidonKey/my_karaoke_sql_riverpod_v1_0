import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/const/const.dart';

class SettingsScreen extends StatelessWidget {
  final double threshold;
  final ValueChanged<double> onThresholdChange;
  const SettingsScreen({
    super.key,
    required this.threshold,
    required this.onThresholdChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                '민감도',
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
        Slider(
          value: threshold,
          onChanged: onThresholdChange,
          min: .1,
          max: 10,
          divisions: 101,
          label: threshold.toStringAsFixed(1),
        )
      ],
    );
  }
}
