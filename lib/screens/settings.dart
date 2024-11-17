import 'package:flutter/material.dart';
import 'package:receipe_project/screens/auth/login_screen.dart';
import 'package:receipe_project/screens/auth/service/UserService.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () {
              UserService.logout(context);
            },
            child: const Text('Sign out'),
          ),
        ),
      ),
    );
  }
}
