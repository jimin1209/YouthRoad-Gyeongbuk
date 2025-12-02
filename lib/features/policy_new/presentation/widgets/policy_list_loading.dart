import 'package:flutter/material.dart';

class PolicyListLoading extends StatelessWidget {
  const PolicyListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
