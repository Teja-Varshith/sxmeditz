import 'package:flutter/material.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';

const _icons = [
  Icons.dashboard_customize_outlined,
  Icons.movie_filter_outlined,
  Icons.smart_display_outlined,
  Icons.image_outlined,
  Icons.insights_outlined,
];

enum _Tone { dark, light, blue }

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 960;
    const gap = 16.0;

    Widget card(int i, {_Tone tone = _Tone.light}) => Reveal(
      delay: Duration(milliseconds: 80 * (i % 3)),
      child: _ServiceCard(index: i, tone: tone),
    );

    final Widget bento;
    if (context.isDesktop) {
      bento = Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: card(0, tone: _Tone.dark)),
                const SizedBox(width: gap),
                Expanded(child: card(1)),
              ],
            ),
          ),
          const SizedBox(height: gap),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: card(2)),
                const SizedBox(width: gap),
                Expanded(child: card(3)),
                const SizedBox(width: gap),
                Expanded(child: card(4, tone: _Tone.blue)),
              ],
            ),
          ),
        ],
      );
    } else if (context.isTablet) {
      Widget pair(int a, int b, {_Tone toneB = _Tone.light}) => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: card(a)),
            const SizedBox(width: gap),
            Expanded(child: card(b, tone: toneB)),
          ],
        ),
      );
      bento = Column(
        children: [
          card(0, tone: _Tone.dark),
          const SizedBox(height: gap),
          pair(1, 2),
          const SizedBox(height: gap),
          pair(3, 4, toneB: _Tone.blue),
        ],
      );
    } else {
      bento = Column(
        children: [
          for (var i = 0; i < services.length; i++) ...[
            if (i > 0) const SizedBox(height: gap),
            card(
              i,
              tone: i == 0 ? _Tone.dark : (i == 4 ? _Tone.blue : _Tone.light),
            ),
          ],
        ],
      );
    }

    return Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Reveal(
            child: Flex(
              direction: wide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: wide
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Kicker('Services'),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 620),
                        child: const SectionTitle(
                          'Everything your content needs, ',
                          highlight: 'in one place.',
                        ),
                      ),
                    ],
                  ),
                ),
                if (wide) const SizedBox(width: 24) else const SizedBox(height: 20),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Text(
                      'Hire me for a single piece or hand over the whole channel. '
                      'Every service is built to get more people watching.',
                      style: AppText.body(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          bento,
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  const _ServiceCard({required this.index, required this.tone});

  final int index;
  final _Tone tone;

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = services[widget.index];
    final (Color bg, Color fg, Color sub) = switch (widget.tone) {
      _Tone.dark => (AppColors.ink, Colors.white, Colors.white70),
      _Tone.blue => (AppColors.blue, AppColors.ink, AppColors.ink),
      _Tone.light => (
        _hover ? Colors.white : AppColors.bg2,
        AppColors.ink,
        AppColors.ink2,
      ),
    };
    final feature = widget.index == 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        constraints: const BoxConstraints(minHeight: 280),
        padding: EdgeInsets.all(
          context.responsive(mobile: 24.0, desktop: 32.0),
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: widget.tone == _Tone.light && _hover
                ? AppColors.blue
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '0${widget.index + 1}',
                  style: AppText.body(
                    size: 14,
                    weight: FontWeight.w700,
                    color: sub,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _hover ? -0.05 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: switch (widget.tone) {
                        _Tone.dark => AppColors.blue,
                        _Tone.blue => Colors.white,
                        _Tone.light => AppColors.blueSoft,
                      },
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _icons[widget.index],
                      color: widget.tone == _Tone.light
                          ? AppColors.blueInk
                          : AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: feature ? 56 : 40),
            Text(
              s.title,
              style: AppText.display(
                size: feature
                    ? context.responsive(mobile: 30.0, desktop: 40.0)
                    : 26,
                color: fg,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Text(s.body, style: AppText.body(size: 16, color: sub)),
            ),
            if (s.tags.isNotEmpty) ...[
              const SizedBox(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in s.tags)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        t,
                        style: AppText.body(
                          size: 13,
                          weight: FontWeight.w600,
                          color: fg,
                          height: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
