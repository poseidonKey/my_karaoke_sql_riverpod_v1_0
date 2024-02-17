import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/favority_song_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/home_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_add_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_search_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/test_data_manage.dart';

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
        GoRoute(
          path: 'searchSong',
          builder: (context, state) => const SongSearchScreen(),
        ),
        GoRoute(
          path: 'testDataManage',
          builder: (context, state) => const TestDataManage(),
        ),
      ],
    ),
  ],
);
