import 'package:flutter/material.dart';
import '../../data/models/policy.dart';
import 'package:go_router/go_router.dart';

class PolicyCard extends StatelessWidget {
  const PolicyCard({super.key, required this.policy});
  final Policy policy;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(policy.title),
        subtitle: Text(policy.summary),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (policy.isNew) const Chip(label: Text('신규')),
            if (policy.endDate != null)
              Text('마감: ${policy.endDate!.toLocal().toString().split(' ').first}'),
          ],
        ),
        onTap: () => context.push('/home/policy/${policy.id}'),
      ),
    );
  }
}
