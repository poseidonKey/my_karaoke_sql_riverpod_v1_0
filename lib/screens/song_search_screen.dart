import 'package:flutter/material.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/layout/defaut_layout.dart';

class SongSearchScreen extends StatelessWidget {
  const SongSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      title: '곡 찾기',
      body: Column(),
    );
  }
}
