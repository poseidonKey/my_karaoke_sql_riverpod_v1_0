import 'package:go_router/go_router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/error_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/favority_song_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/home_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_add_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/song_search_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/splash_screen.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/screens/test_data_manage_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      // builder: (context, state) => const TestDataManage(),
      // builder: (context, state) => const AuthScreen(),
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
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
        ])
  ],
  errorBuilder: (context, state) => ErrorScreen(
    error: state.error.toString(),
  ),
  debugLogDiagnostics: true,
  // redirect: (context, state) async {
  //   if (state.uri.toString() == '/') {
  //     await showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('확인'),
  //         content: const Text('Wifi가 연결 되지 않아 내장 DB를 이용합니다.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('확인'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //   return null;
  // },
);
