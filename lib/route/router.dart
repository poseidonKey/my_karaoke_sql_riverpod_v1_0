import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/favority_song_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/home_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_add_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
      routes: [
        GoRoute(
          path: 'songAdd',
          builder: (context, state) => const SongAddScreen(),
        ),
        GoRoute(
          path: 'favoritySong',
          builder: (context, state) => const FavoritySongScreen(),
        ),
      ],
    ),
  ],
);
