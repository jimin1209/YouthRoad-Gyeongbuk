import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('지역/관심분야 다시 설정'),
            onTap: () => context.go('/onboarding'),
          ),
          const ListTile(
            title: Text('앱 정보'),
            subtitle: Text('경북 청년 정책 추천 앱'),
          ),
        ],
      ),
    );
  }
}
