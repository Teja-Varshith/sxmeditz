import 'package:flutter/material.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cardW = context.responsive(mobile: 300.0, desktop: 400.0);
    const cardH = 250.0;

    List<Widget> cards(List<Review> list, int offset) => [
      for (var i = 0; i < list.length; i++)
        _ReviewCard(
          review: list[i],
          width: cardW,
          height: cardH,
          variant: i + offset,
        ),
    ];

    final firstRow = reviews;
    final secondRow = [...reviews.skip(2), ...reviews.take(2)];

    return Column(
      children: [
        Section(
          vertical: 0,
          child: Padding(
            padding: EdgeInsets.only(
              top: context.responsive(mobile: 80.0, desktop: 120.0),
              bottom: 48,
            ),
            child: Reveal(
              child: Column(
                children: [
                  const Kicker('Kind words'),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: const SectionTitle(
                      'Creators who stopped ',
                      highlight: 'worrying about content.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Marquee(
          height: cardH,
          gap: 20,
          speed: 40,
          children: cards(firstRow, 0),
        ),
        const SizedBox(height: 20),
        Marquee(
          height: cardH,
          gap: 20,
          speed: 40,
          reverse: true,
          children: cards(secondRow, 2),
        ),
        SizedBox(height: context.responsive(mobile: 80.0, desktop: 120.0)),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.review,
    required this.width,
    required this.height,
    required this.variant,
  });

  final Review review;
  final double width;
  final double height;
  final int variant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.bg2,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (_) => const Icon(
                Icons.star_rounded,
                color: AppColors.blue,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Text(
              '“${review.quote}”',
              style: AppText.body(
                size: 16,
                color: AppColors.ink,
                weight: FontWeight.w600,
                height: 1.5,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: MediaPlaceholder(variant: variant, radius: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      review.detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(
                        size: 13,
                        color: AppColors.muted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
