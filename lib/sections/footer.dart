import 'package:flutter/material.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, required this.onNavigate});

  final void Function(String id) onNavigate;

  @override
  Widget build(BuildContext context) {
    final linkStyle = AppText.body(
      size: 14,
      weight: FontWeight.w600,
      color: Colors.white70,
      height: 1,
    );

    return Section(
      color: AppColors.ink,
      vertical: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 48, bottom: 32),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Oversized wordmark that scales to the container width.
            ExcludeSemantics(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  const TextSpan(
                    children: [
                      TextSpan(text: 'SXM'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: AppColors.blue),
                      ),
                      TextSpan(text: 'EDITX'),
                    ],
                  ),
                  style: AppText.display(
                    size: 200,
                    color: Colors.white.withValues(alpha: 0.95),
                    height: 0.9,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 24,
              runSpacing: 20,
              children: [
                Text(
                  '© ${DateTime.now().year} $brandName. All rights reserved.',
                  style: AppText.body(
                    size: 14,
                    color: Colors.white54,
                    height: 1,
                  ),
                ),
                Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  children: [
                    for (final id in ['Work', 'Services', 'FAQ', 'Contact'])
                      InkWell(
                        onTap: () => onNavigate(id.toLowerCase()),
                        child: Text(id, style: linkStyle),
                      ),
                    for (final s in socials)
                      InkWell(
                        onTap: () => openUrl(s.url),
                        child: Text('${s.label} ↗', style: linkStyle),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
