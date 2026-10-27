import 'package:flutter/material.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key, required this.onNavigate});

  final void Function(String id) onNavigate;

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 960;

    final intro = Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Kicker('How it works'),
          const SectionTitle(
            'From first call to ',
            highlight: 'first million.',
          ),
          const SizedBox(height: 20),
          Text(
            'A simple process with clear deadlines, so you always know where your content stands.',
            style: AppText.body(),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Start a project',
            arrow: true,
            onPressed: () => onNavigate('contact'),
          ),
        ],
      ),
    );

    final steps = Column(
      children: [
        for (var i = 0; i < processSteps.length; i++)
          Reveal(
            delay: Duration(milliseconds: 80 * i),
            child: _StepTile(
              index: i,
              step: processSteps[i],
              last: i == processSteps.length - 1,
            ),
          ),
      ],
    );

    return Section(
      color: AppColors.bg2,
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: intro),
                const SizedBox(width: 80),
                Expanded(flex: 6, child: steps),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [intro, const SizedBox(height: 48), steps],
            ),
    );
  }
}

class _StepTile extends StatefulWidget {
  const _StepTile({
    required this.index,
    required this.step,
    required this.last,
  });

  final int index;
  final ProcessStep step;
  final bool last;

  @override
  State<_StepTile> createState() => _StepTileState();
}

class _StepTileState extends State<_StepTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Number + connecting line
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _hover ? AppColors.blue : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _hover ? AppColors.blue : AppColors.line,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    '0${widget.index + 1}',
                    style: AppText.display(size: 18, height: 1),
                  ),
                ),
                if (!widget.last)
                  Expanded(child: Container(width: 1.5, color: AppColors.line)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 12, bottom: widget.last ? 0 : 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.step.title,
                      style: AppText.display(
                        size: 24,
                        weight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.step.body, style: AppText.body(size: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
