import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/firebase_options.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/route/router.dart';
import 'package:my_karaoke_sql_riverpod_v1_0/route/router_use_wifi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// Check connectivity
  final result = await Connectivity().checkConnectivity();

  // Decide which MaterialApp to run based on connectivity
  Widget app;
  if (result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile) {
    app = const MyAppWithRouter();
  } else {
    app = const MyAppWithoutRouter();
  }

  runApp(app);
}

class MyAppWithRouter extends StatelessWidget {
  const MyAppWithRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: routerUseWifi,
      ),
    );
  }
}

class MyAppWithoutRouter extends StatelessWidget {
  const MyAppWithoutRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
