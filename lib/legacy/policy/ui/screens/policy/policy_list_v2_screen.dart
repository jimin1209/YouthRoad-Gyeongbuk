import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youth_road_app/features/policy_new/presentation/screens/policy_feed_home_screen.dart';

class PolicyListV2Screen extends ConsumerWidget {
  const PolicyListV2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PolicyFeedHomeScreen();
  }
}
