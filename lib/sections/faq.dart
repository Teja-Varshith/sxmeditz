import 'package:flutter/material.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';

class FaqSection extends StatefulWidget {
  const FaqSection({super.key, required this.onNavigate});

  final void Function(String id) onNavigate;

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? _open = 0;

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 960;

    final intro = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Kicker('FAQ'),
          const SectionTitle('Questions, ', highlight: 'answered.'),
          const SizedBox(height: 20),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Have a different question? ', style: AppText.body()),
              InkWell(
                onTap: () => widget.onNavigate('contact'),
                child: Text(
                  'Send me a message',
                  style:
                      AppText.body(
                        weight: FontWeight.w700,
                        color: AppColors.blueInk,
                      ).copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.blueInk,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final list = Column(
      children: [
        for (var i = 0; i < faqs.length; i++)
          Reveal(
            delay: Duration(milliseconds: 50 * i),
            child: _FaqItem(
              faq: faqs[i],
              open: _open == i,
              onTap: () => setState(() => _open = _open == i ? null : i),
            ),
          ),
      ],
    );

    return Section(
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: intro),
                const SizedBox(width: 72),
                Expanded(flex: 6, child: list),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [intro, const SizedBox(height: 40), list],
            ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.faq, required this.open, required this.onTap});

  final Faq faq;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            button: true,
            expanded: open,
            child: InkWell(
              onTap: onTap,
              hoverColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        faq.q,
                        style: AppText.display(
                          size: context.responsive(mobile: 19.0, desktop: 22.0),
                          weight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    AnimatedContainer(
                      duration: duration,
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: open ? AppColors.blue : AppColors.bg2,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedRotation(
                        turns: open ? 0.125 : 0,
                        duration: duration,
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppColors.ink,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: duration,
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 24, right: 52),
                    child: Text(faq.a, style: AppText.body(size: 16)),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}
