import 'package:flutter_riverpod/flutter_riverpod.dart';

final songCountFirebaseProvider = StateProvider<int>(
  (ref) => 0,
);
final songsAllCountFirebaseProvider = StateProvider<int>(
  (ref) => 0,
);
