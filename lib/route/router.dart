import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/auth_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/error_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/favority_song_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/home_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/home_screen_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_add_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_search_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_search_screen_fb.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/test_data_manage_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      // builder: (context, state) => const TestDataManage(),
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/home',
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
          builder: (context, state) => SongSearchScreen(),
        ),
        GoRoute(
          path: 'testDataManage',
          builder: (context, state) => const TestDataManage(),
        ),
      ],
    ),
    GoRoute(
        path: '/home_fb',
        builder: (context, state) {
          return const HomeScreenFirebase();
        },
        routes: [
          GoRoute(
            path: 'searchSongFb',
            builder: (context, state) => SongSearchScreenFirebase(),
          ),
        ])
  ],
  errorBuilder: (context, state) => ErrorScreen(
    error: state.error.toString(),
  ),
  debugLogDiagnostics: true,
);
