import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/app_appbar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  static const _notificationsKey = 'settings_notifications_enabled';

  bool _notificationsEnabled = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      _loading = false;
    });
  }

  void _toggleNotification(bool value) async {
    setState(() => _notificationsEnabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: '설정'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SwitchListTile(
                  title: const Text('알림 수신'),
                  value: _notificationsEnabled,
                  onChanged: _toggleNotification,
                ),
                const ListTile(
                  title: Text('앱 버전'),
                  subtitle: Text('1.0.0'),
                ),
              ],
            ),
    );
  }
}
