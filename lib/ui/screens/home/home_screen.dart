import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../widgets/app_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.homeTitle),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
