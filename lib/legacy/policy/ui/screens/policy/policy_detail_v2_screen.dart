import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youth_road_app/features/policy_new/presentation/detail/policy_detail_bottom_sheet.dart';

class PolicyDetailV2Screen extends ConsumerWidget {
  const PolicyDetailV2Screen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: PolicyDetailBottomSheet(policyId: id),
    );
  }
}
