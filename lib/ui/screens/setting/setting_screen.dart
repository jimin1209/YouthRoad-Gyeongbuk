import 'package:flutter/material.dart';

import '../../widgets/app_appbar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: '설정'),
      body: ListView(
        children: const [
          SwitchListTile(
            title: Text('알림 수신'),
            value: true,
            onChanged: null, // TODO: implement preferences toggle
          ),
          ListTile(
            title: Text('앱 버전'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
