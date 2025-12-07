import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> _launchTel(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWeb(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyAddress(BuildContext context) {
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('주소가 복사되었습니다.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: true,
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.55,
        maxChildSize: 0.9,
        builder: (context, controller) {
          return Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 20,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: SingleChildScrollView(
                controller: controller,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4,
                        width: 56,
                        decoration: BoxDecoration(
                          color: colors.onSurface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            regionLabel,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '기본 정보',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.place,
                      label: '주소',
                      value: address,
                    ),
                    if (phone != null && phone!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.phone,
                        label: '전화번호',
                        value: phone!,
                      ),
                    ],
                    if (homepageUrl != null && homepageUrl!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.public,
                        label: '웹사이트',
                        value: homepageUrl!,
                      ),
                    ],
                    const SizedBox(height: 22),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        FilledButton.icon(
                          onPressed: phone != null && phone!.isNotEmpty
                              ? () => _launchTel(phone!)
                              : null,
                          icon: const Icon(Icons.phone),
                          label: const Text('전화 걸기'),
                        ),
                        FilledButton.icon(
                          onPressed: homepageUrl != null && homepageUrl!.isNotEmpty
                              ? () => _launchWeb(homepageUrl!)
                              : null,
                          icon: const Icon(Icons.launch),
                          label: const Text('홈페이지'),
                        ),
                        FilledButton.icon(
                          onPressed: () => _copyAddress(context),
                          icon: const Icon(Icons.copy),
                          label: const Text('주소 복사'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.onSurface.withOpacity(0.65),
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
