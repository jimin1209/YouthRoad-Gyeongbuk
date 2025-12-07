import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CenterDetailBottomSheet extends StatelessWidget {
  final String name;
  final String address;
  final String? phone;
  final String? homepageUrl;
  final String regionLabel;

  const CenterDetailBottomSheet({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
    required this.homepageUrl,
    required this.regionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            regionLabel,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            address,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          if (phone != null && phone!.isNotEmpty)
            GestureDetector(
              onTap: () => launchUrl(Uri.parse('tel:$phone')),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '전화: $phone',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          if (homepageUrl != null && homepageUrl!.isNotEmpty)
            GestureDetector(
              onTap: () => launchUrl(
                Uri.parse(homepageUrl!),
                mode: LaunchMode.externalApplication,
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  '센터 홈페이지 바로가기',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('닫기'),
            ),
          )
        ],
      ),
    );
  }
}
