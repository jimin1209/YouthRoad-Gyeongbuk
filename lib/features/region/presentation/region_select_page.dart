import 'package:flutter/material.dart';

class RegionSelectPage extends StatelessWidget {
  const RegionSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('지역 선택')),
      body: const Center(child: Text('Unity 지도와 리스트를 통한 지역 선택 UI 예정')),
    );
  }
}
