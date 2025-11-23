import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/providers.dart';
import '../../widgets/app_appbar.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final notifications = prefs.getBool('notifications') ?? true;

    return Scaffold(
      appBar: const AppAppBar(title: '설정'),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('알림 수신'),
            value: notifications,
            onChanged: (value) {
              prefs.setBool('notifications', value);
              ref.refresh(regionProvider);
            },
          ),
          ListTile(
            title: const Text('AI 챗 기록 초기화'),
            onTap: () => ref.read(chatProvider.notifier).clearHistory(),
          ),
          ListTile(
            title: const Text('저장된 지역 초기화'),
            onTap: () {
              ref.read(regionProvider.notifier).clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('지역 설정이 초기화되었습니다.')),
              );
            },
          ),
          ListTile(
            title: const Text('저장소 전체 초기화'),
            onTap: () async {
              await prefs.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('앱 설정이 모두 초기화되었습니다.')),
              );
            },
          ),
          const ListTile(
            title: Text('앱 버전'),
            subtitle: Text('1.0.0 (mock)'),
          ),
        ],
      ),
    );
  }
}
