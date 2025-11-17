import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../widgets/app_appbar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.settingTitle),
      body: const Center(
        child: Text('Setting Screen'),
      ),
    );
  }
}
