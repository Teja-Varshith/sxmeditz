import 'package:flutter/material.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';

class WorkSection extends StatefulWidget {
  const WorkSection({super.key});

  @override
  State<WorkSection> createState() => _WorkSectionState();
}

class _WorkSectionState extends State<WorkSection> {
  WorkCategory? _filter; // null = All

  @override
  Widget build(BuildContext context) {
    final items = workItems
        .where((w) => _filter == null || w.category == _filter)
        .toList();
    final wide = context.screenWidth >= 960;

    final filters = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _FilterChip(
          label: 'All',
          selected: _filter == null,
          onTap: () => setState(() => _filter = null),
        ),
        for (final c in WorkCategory.values)
          _FilterChip(
            label: c.label,
            selected: _filter == c,
            onTap: () => setState(() => _filter = c),
          ),
      ],
    );

    return Section(
      color: AppColors.bg2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Reveal(
            child: Flex(
              direction: wide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: wide
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flexible so a Row layout (wide) can shrink/wrap these
                // instead of overflowing when the viewport is tight.
                Flexible(
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Kicker('Selected work'),
                      SectionTitle('Made to be ', highlight: 'watched.'),
                    ],
                  ),
                ),
                if (!wide) const SizedBox(height: 24),
                if (wide) const SizedBox(width: 24),
                Flexible(child: filters),
              ],
            ),
          ),
          const SizedBox(height: 48),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOut,
            child: _Masonry(
              key: ValueKey(_filter),
              items: items,
              columns: context.responsive(
                mobile: context.screenWidth < 520 ? 1 : 2,
                desktop: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Places each card in the currently shortest column.
class _Masonry extends StatelessWidget {
  const _Masonry({super.key, required this.items, required this.columns});

  final List<WorkItem> items;
  final int columns;

  static const _gap = 20.0;
  static const _metaHeight = 0.32; // relative to column width

  @override
  Widget build(BuildContext context) {
    final cols = List.generate(columns, (_) => <(int, WorkItem)>[]);
    final heights = List.filled(columns, 0.0);
    for (var i = 0; i < items.length; i++) {
      var target = 0;
      for (var c = 1; c < columns; c++) {
        if (heights[c] < heights[target] - 0.01) target = c;
      }
      cols[target].add((i, items[i]));
      heights[target] += 1 / items[i].aspectRatio + _metaHeight;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var c = 0; c < columns; c++) ...[
          if (c > 0) const SizedBox(width: _gap),
          Expanded(
            child: Column(
              children: [
                for (final (i, item) in cols[c])
                  Padding(
                    padding: const EdgeInsets.only(bottom: _gap * 1.6),
                    child: Reveal(
                      delay: Duration(milliseconds: 60 * (i % 3)),
                      child: _WorkCard(item: item, index: i),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({required this.item, required this.index});

  final WorkItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isSocial = item.category == WorkCategory.social;
    final playable =
        item.category == WorkCategory.reels ||
        item.category == WorkCategory.edits;

    return Semantics(
      container: true,
      label: '${item.category.label}: ${item.title}',
      child: HoverLift(
        onTap: item.link == null ? null : () => openUrl(item.link!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: item.aspectRatio,
              child: isSocial
                  ? _GrowthCard(item: item, dark: index.isOdd)
                  : MediaPlaceholder(
                      variant: index,
                      label: item.image == null
                          ? '${item.category.label} ${index + 1}'
                          : null,
                      image: item.image,
                      showPlay: playable,
                    ),
            ),
            const SizedBox(height: 14),
            Text(
              item.title,
              style: AppText.display(
                size: 20,
                weight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: isSocial ? item.metric : '${item.client} · '),
                  if (!isSocial)
                    TextSpan(
                      text: item.metric,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
              style: AppText.body(
                size: 14,
                color: AppColors.muted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Before → after follower growth card for social media management work.
class _GrowthCard extends StatelessWidget {
  const _GrowthCard({required this.item, required this.dark});

  final WorkItem item;
  final bool dark;

  static const _bars = [0.18, 0.26, 0.31, 0.45, 0.58, 0.72, 0.96];

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppColors.ink;
    final sub = dark ? Colors.white60 : AppColors.muted;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: dark ? AppColors.ink : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: dark ? null : Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.blue, Color(0xFF0F4C63)],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.handle ?? '',
                      style: AppText.body(
                        size: 15,
                        weight: FontWeight.w700,
                        color: fg,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      item.client,
                      style: AppText.body(size: 12, color: sub, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < _bars.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: _bars[i],
                      child: Container(
                        decoration: BoxDecoration(
                          color: i == _bars.length - 1
                              ? AppColors.blue
                              : AppColors.blue.withValues(
                                  alpha: dark ? 0.35 : 0.22,
                                ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${item.growthFrom} '),
                  const TextSpan(
                    text: '→ ',
                    style: TextStyle(color: AppColors.blue),
                  ),
                  TextSpan(text: item.growthTo),
                ],
              ),
              style: AppText.display(size: 34, color: fg, height: 1),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.growthUnit ?? '',
            style: AppText.body(size: 13, color: sub, height: 1.2),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              color: selected ? AppColors.ink : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: selected ? AppColors.ink : AppColors.line,
              ),
            ),
            child: Text(
              label,
              style: AppText.body(
                size: 14,
                weight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.ink,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
