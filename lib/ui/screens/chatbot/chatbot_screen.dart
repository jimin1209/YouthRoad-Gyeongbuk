import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../widgets/app_appbar.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.chatbotTitle),
      body: const Center(
        child: Text('Chatbot Screen'),
      ),
    );
  }
}
