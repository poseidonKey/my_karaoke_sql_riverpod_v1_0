import 'package:flutter_riverpod/flutter_riverpod.dart';

final songCountProvider = StateProvider<int>(
  (ref) => 0,
);
final songsAllCountProvider = StateProvider<int>(
  (ref) => 0,
);
