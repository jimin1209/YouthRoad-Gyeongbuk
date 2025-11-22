import 'package:flutter/material.dart';

/// 상세 요약/제출서류/문의처를 접기 형태로 묶은 UI (mock 데이터 기반).
class PolicyDetailSections extends StatelessWidget {
  const PolicyDetailSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ExpandableSection(
          title: '정책 간단 요약',
          body: '• 목적: 청년 주거 안정\n• 대상: 만 19~34세 경북 거주 청년\n• 혜택: 보증금 지원 최대 1,000만원',
        ),
        SizedBox(height: 8),
        _ExpandableSection(
          title: '제출서류 체크리스트',
          body: '□ 주민등록등본\n□ 신분증 사본\n□ 소득금액증명원\n□ 임대차계약서 사본',
        ),
        SizedBox(height: 8),
        _ExpandableSection(
          title: '문의처',
          body: '경북청년센터 054-000-0000\nhelp@gbyouth.kr',
        ),
      ],
    );
  }
}

class _ExpandableSection extends StatelessWidget {
  const _ExpandableSection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(body),
          ),
        ],
      ),
    );
  }
}
