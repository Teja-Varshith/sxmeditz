import 'package:flutter/material.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';

class PackagesSection extends StatelessWidget {
  const PackagesSection({super.key, required this.onNavigate});

  final void Function(String id) onNavigate;

  @override
  Widget build(BuildContext context) {
    final cards = [
      for (var i = 0; i < plans.length; i++)
        Reveal(
          delay: Duration(milliseconds: 100 * i),
          child: _PlanCard(
            plan: plans[i],
            fill: context.isDesktop,
            onQuote: () => onNavigate('contact'),
          ),
        ),
    ];

    return Section(
      color: AppColors.bg2,
      child: Column(
        children: [
          const Reveal(
            child: Column(
              children: [
                Kicker('Ways to work together'),
                SectionTitle(
                  'Pick what fits. ',
                  highlight: 'Upgrade anytime.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 56),
          if (context.isDesktop)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(width: 20),
                    Expanded(child: cards[i]),
                  ],
                ],
              ),
            )
          else
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    if (i > 0) const SizedBox(height: 20),
                    cards[i],
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.onQuote,
    required this.fill,
  });

  final Plan plan;
  final VoidCallback onQuote;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final pop = plan.popular;
    final fg = pop ? Colors.white : AppColors.ink;
    final sub = pop ? Colors.white70 : AppColors.ink2;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: pop ? AppColors.ink : Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: pop ? null : Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.name,
                  style: AppText.display(size: 28, color: fg, height: 1.1),
                ),
              ),
              if (pop)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'Most popular',
                    style: AppText.body(
                      size: 12,
                      weight: FontWeight.w700,
                      color: AppColors.ink,
                      height: 1,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(plan.desc, style: AppText.body(size: 15, color: sub)),
          const SizedBox(height: 24),
          Divider(color: pop ? Colors.white12 : AppColors.line, height: 1),
          const SizedBox(height: 24),
          for (final f in plan.features)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.blue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      f,
                      style: AppText.body(size: 15, color: fg, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          // Pushes the button to the bottom when cards share a row height.
          if (fill) const Spacer(),
          AppButton(
            label: 'Get a quote',
            expand: true,
            variant: pop ? ButtonVariant.blue : ButtonVariant.ghost,
            onPressed: onQuote,
          ),
        ],
      ),
    );
  }
}
