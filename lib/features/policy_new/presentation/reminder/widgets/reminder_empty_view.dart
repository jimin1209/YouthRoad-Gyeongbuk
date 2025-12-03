import 'package:flutter/material.dart';

class ReminderEmptyView extends StatelessWidget {
  const ReminderEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_none, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('예약된 알림이 없습니다.'),
        ],
      ),
    );
  }
}
