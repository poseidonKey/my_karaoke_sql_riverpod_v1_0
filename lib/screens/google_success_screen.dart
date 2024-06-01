import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GoogleSuccessScreen extends StatelessWidget {
  const GoogleSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: Container(
        child: Text('login success. email:${user?.email}'),
      ),
    );
  }
}
