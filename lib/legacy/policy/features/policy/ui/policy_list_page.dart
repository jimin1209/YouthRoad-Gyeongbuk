import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youth_road_app/features/policy_new/presentation/screens/policy_feed_home_screen.dart';

class PolicyListPage extends ConsumerWidget {
  const PolicyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PolicyFeedHomeScreen();
  }
}
