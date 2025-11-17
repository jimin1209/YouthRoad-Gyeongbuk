import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../widgets/app_appbar.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.categoryTitle),
      body: const Center(
        child: Text('Category Screen'),
      ),
    );
  }
}
