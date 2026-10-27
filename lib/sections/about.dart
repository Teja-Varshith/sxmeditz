import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';

// ────────────────────────────────────────────────────────────────────
//  ABOUT — "printed poster" direction (matches the hero)
//
//  White background, warm paper cards, ONE brand blue. Hard offset
//  shadows, tape, tilted stickers, halftone patch, serif-italic word,
//  brush underline. No glows, no gradients.
// ────────────────────────────────────────────────────────────────────

const _paper = Color(0xFFF1EBDD);
const _paperInk = Color(0xFF141414);

// ────────────────────────────────────────────────────────────────────
//  SERVICE BAND — tilted paper tape, scrolling services
// ────────────────────────────────────────────────────────────────────

class ServiceBand extends StatelessWidget {
  const ServiceBand({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.responsive(mobile: 22.0, desktop: 34.0);
    final words = <Widget>[];
    for (final w in marqueeWords) {
      words
        ..add(
          Text(
            w.toUpperCase(),
            style: AppText.display(
              size: size,
              height: 1,
              color: _paperInk,
            ).copyWith(letterSpacing: size * 0.04),
          ),
        )
        ..add(
          Icon(Icons.auto_awesome, color: AppColors.blue, size: size * 0.7),
        );
    }

    return Semantics(
      label: 'Services: ${marqueeWords.join(', ')}',
      child: ExcludeSemantics(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: context.responsive(mobile: 26.0, desktop: 40.0),
          ),
          child: ClipRect(
            child: Transform.rotate(
              angle: -0.02,
              child: Transform.scale(
                scaleX: 1.1,
                child: Container(
                  decoration: BoxDecoration(
                    color: _paper,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Marquee(
                    height: size * 1.3,
                    gap: 32,
                    speed: 70,
                    children: words,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  ABOUT SECTION
// ────────────────────────────────────────────────────────────────────

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = context.screenWidth >= 960;
    final hPad = context.responsive(mobile: 20.0, tablet: 28.0, desktop: 36.0);
    final vPad = context.responsive(mobile: 64.0, desktop: 104.0);

    final copy = const _AboutCopy();

    final grid = GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      clipBehavior: Clip.none, // let shadows + tape breathe
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(6, 14, 12, 12),
      mainAxisSpacing: 22,
      crossAxisSpacing: 22,
      childAspectRatio: context.responsive(mobile: 1.05, desktop: 1.3),
      children: [
        for (var i = 0; i < stats.length; i++)
          Reveal(
            delay: Duration(milliseconds: 100 * i),
            child: _StatCard(stats[i], index: i, highlighted: i == 1),
          ),
      ],
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: ClipRect(
        child: Stack(
          children: [
            const Positioned.fill(child: _AboutBackdrop()),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 6, child: copy),
                            const SizedBox(width: 64),
                            Expanded(flex: 6, child: grid),
                          ],
                        )
                      : Column(
                          children: [copy, const SizedBox(height: 44), grid],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  COPY COLUMN
// ────────────────────────────────────────────────────────────────────

class _AboutCopy extends StatelessWidget {
  const _AboutCopy();

  @override
  Widget build(BuildContext context) {
    final titleSize = context.responsive(
      mobile: 36.0,
      tablet: 46.0,
      desktop: 54.0,
    );
    final bodySize = context.responsive(mobile: 16.0, desktop: 18.0);

    final base = AppText.display(
      size: titleSize,
      height: 1.02,
    ).copyWith(color: _paperInk, letterSpacing: -titleSize * 0.02);
    final serif = base.copyWith(
      fontFamily: 'Georgia',
      fontFamilyFallback: const ['Times New Roman', 'serif'],
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
      color: _paperInk,
      letterSpacing: 0,
    );

    return Reveal(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _KickerSticker('ABOUT'),
          const SizedBox(height: 26),
          Semantics(
            header: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                    style: base,
                    children: [
                      const TextSpan(text: "Hey, I'm the\n"),
                      TextSpan(text: 'person ', style: serif),
                      const TextSpan(text: 'behind'),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      'SXM.EDITX.',
                      style: base.copyWith(color: AppColors.blue),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -titleSize * 0.14,
                      height: titleSize * 0.2,
                      child: CustomPaint(painter: _BrushUnderlinePainter()),
                    ),
                  ],
                ),
                SizedBox(height: titleSize * 0.2),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Text.rich(
              TextSpan(
                style: AppText.body(
                  size: bodySize,
                  color: _paperInk.withValues(alpha: 0.72),
                ),
                children: [
                  const TextSpan(
                    text:
                        'I edit videos, design thumbnails and run social media '
                        'accounts for creators and brands. I start from what makes '
                        'someone ',
                  ),
                  TextSpan(
                    text: 'stop and watch',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ', and build every cut, frame and caption around that.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Text(
              'Whether you need one viral reel or someone to run your whole '
              'content calendar, you get one person who understands the full '
              'picture — from idea to upload to analytics.',
              style: AppText.body(
                size: bodySize,
                color: _paperInk.withValues(alpha: 0.72),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const _FlowSticker(),
        ],
      ),
    );
  }
}

/// Tilted blue label, like a strip of printed tape.
class _KickerSticker extends StatelessWidget {
  const _KickerSticker(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.04,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.blue,
          boxShadow: [
            BoxShadow(
              color: _paper.withValues(alpha: 0.9),
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Text(
          label,
          style: AppText.display(
            size: 14,
            weight: FontWeight.w900,
            color: Colors.white,
            height: 1,
          ).copyWith(letterSpacing: 2.2),
        ),
      ),
    );
  }
}

/// "IDEA → UPLOAD → ANALYTICS" paper sticker.
class _FlowSticker extends StatelessWidget {
  const _FlowSticker();

  @override
  Widget build(BuildContext context) {
    final style = AppText.body(
      size: 12,
      weight: FontWeight.w800,
      color: _paperInk,
      height: 1,
    ).copyWith(letterSpacing: 1.6);

    Widget arrow() => const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Icon(Icons.arrow_forward_rounded, size: 14, color: _paperInk),
    );

    return Transform.rotate(
      angle: 0.012,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _paper,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('IDEA', style: style),
            arrow(),
            Text('UPLOAD', style: style),
            arrow(),
            Text('ANALYTICS', style: style.copyWith(color: AppColors.blue)),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  BACKDROP — halftone patch + a few "+" marks
// ────────────────────────────────────────────────────────────────────

class _AboutBackdrop extends StatelessWidget {
  const _AboutBackdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Transform.flip(
              flipY: true,
              child: const SizedBox(
                width: 320,
                height: 320,
                child: CustomPaint(painter: _HalftonePainter()),
              ),
            ),
          ),
          for (final a in const [
            Alignment(0.96, -0.82),
            Alignment(-0.97, -0.3),
            Alignment(0.04, 0.9),
          ])
            Align(
              alignment: a,
              child: Icon(
                Icons.add_rounded,
                size: 16,
                color: _paperInk.withValues(alpha: 0.18),
              ),
            ),
        ],
      ),
    );
  }
}

class _HalftonePainter extends CustomPainter {
  const _HalftonePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 14.0;
    final paint = Paint()..color = AppColors.blue.withValues(alpha: 0.3);
    final rows = (size.height / gap).floor();
    final cols = (size.width / gap).floor();
    for (int r = 0; r <= rows; r++) {
      for (int c = 0; c <= cols; c++) {
        final x = c * gap + (r.isOdd ? gap / 2 : 0);
        final y = r * gap;
        final t = ((1 - x / size.width) + (1 - y / size.height)) / 2;
        final radius = 4.0 * math.pow(t.clamp(0.0, 1.0), 1.7);
        if (radius < 0.6) continue;
        canvas.drawCircle(Offset(x, y), radius.toDouble(), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BrushUnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final main = Paint()
      ..color = AppColors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;
    final thin = Paint()
      ..color = AppColors.blue.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final p1 = Path()
      ..moveTo(w * 0.01, h * 0.55)
      ..cubicTo(w * 0.22, h * 0.05, w * 0.5, h * 0.95, w * 0.74, h * 0.4)
      ..quadraticBezierTo(w * 0.9, h * 0.1, w * 0.99, h * 0.5);
    final p2 = Path()
      ..moveTo(w * 0.12, h * 0.95)
      ..cubicTo(w * 0.35, h * 0.55, w * 0.6, h * 1.0, w * 0.86, h * 0.7);

    canvas.drawPath(p1, main);
    canvas.drawPath(p2, thin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ────────────────────────────────────────────────────────────────────
//  STAT CARD — paper card, tape, tilt, hard shadow, count-up number
// ────────────────────────────────────────────────────────────────────

class _StatCard extends StatefulWidget {
  const _StatCard(this.stat, {required this.index, this.highlighted = false});

  final Stat stat;
  final int index;
  final bool highlighted;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  static const _tilts = [-0.016, 0.012, 0.010, -0.012];

  final _key = UniqueKey();
  bool _started = false;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final hl = widget.highlighted;
    final fg = hl ? Colors.white : _paperInk;
    final suffixColor = hl ? _paper : AppColors.blue;
    final numberSize = context.responsive(mobile: 42.0, desktop: 58.0);
    final tilt = _tilts[widget.index % _tilts.length];

    final shadowColor = _hover
        ? (hl ? _paper : AppColors.blue)
        : Colors.black.withValues(alpha: 0.5);

    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (!_started && info.visibleFraction > 0.4) {
          setState(() => _started = true);
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                transformAlignment: Alignment.center,
                transform: Matrix4.translationValues(0, _hover ? -5 : 0, 0)
                  ..rotateZ(_hover ? 0.0 : tilt),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: hl ? AppColors.blue : _paper,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      offset: _hover ? const Offset(7, 7) : const Offset(5, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.stat.label.toUpperCase(),
                      style: AppText.body(
                        size: 12,
                        weight: FontWeight.w800,
                        color: hl
                            ? Colors.white.withValues(alpha: 0.85)
                            : _paperInk.withValues(alpha: 0.6),
                        height: 1.2,
                      ).copyWith(letterSpacing: 1.6),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0,
                        end: _started || context.reduceMotion
                            ? widget.stat.value.toDouble()
                            : 0,
                      ),
                      duration: const Duration(milliseconds: 1600),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, _) => FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: v.round().toString()),
                              TextSpan(
                                text: widget.stat.suffix,
                                style: TextStyle(color: suffixColor),
                              ),
                            ],
                          ),
                          style: AppText.display(
                            size: numberSize,
                            color: fg,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // strip of tape on top of the card
            Positioned(
              top: -9,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: Transform.rotate(
                    angle: widget.index.isEven ? 0.05 : -0.05,
                    child: Container(
                      width: 54,
                      height: 16,
                      color: hl
                          ? _paper.withValues(alpha: 0.9)
                          : AppColors.blue.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
