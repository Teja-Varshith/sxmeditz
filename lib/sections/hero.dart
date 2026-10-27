import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/content.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'header.dart';

// ────────────────────────────────────────────────────────────────────
//  HERO — "printed poster" direction
//
//  Flat ink background, warm paper accent, ONE brand blue.
//  No glows, no gradients, no reticles. Hard offset shadows, tape,
//  stickers, a misregistered blob, halftone dots, hand-drawn arrows.
//
//  REQUIRED: add `final String? cutout;` to your Creator model
//  (path to a transparent PNG, cropped at the hands).
//
//  CHANGES IN THIS VERSION
//  • Tagline "NO BS. YOUR BRAND, OUR STRATEGY."
//  • Scrolling tilted tape strip at the bottom (REELS · YOUTUBE EDITS ·
//    CONTENT PACKAGING) separating the hero from the next section
//  • Creator dial auto-advances (pauses on hover / drag); prev/next
//    buttons removed (ticks, drag, wheel and ← → keys still work)
//  • Work cards simplified: thumbnail + view count only
// ────────────────────────────────────────────────────────────────────

const _paper = Color(0xFFF1EBDD);
const _paperInk = Color(0xFF141414);

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.onNavigate});

  final void Function(String id) onNavigate;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return ClipRect(
      child: Container(
        width: double.infinity,
        color: AppColors.ink,
        child: Stack(
          children: [
            const Positioned.fill(child: _HeroBackdrop()),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1280),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsive(
                          mobile: 16.0,
                          tablet: 24.0,
                          desktop: 36.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height:
                                SiteHeader.height +
                                context.responsive(mobile: 14.0, desktop: 16.0),
                          ),
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12.0,
                                      right: 32.0,
                                    ),
                                    child: _HeroCopy(
                                      onNavigate: onNavigate,
                                      alignLeft: true,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  flex: 7,
                                  child: _ArcDialerSection(),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                _HeroCopy(
                                  onNavigate: onNavigate,
                                  alignLeft: false,
                                ),
                                const SizedBox(height: 28),
                                const _ArcDialerSection(),
                              ],
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                const _TapeStrip(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  BACKDROP — halftone patch, squiggle, sparkles, a few "+" marks
// ────────────────────────────────────────────────────────────────────

class _HeroBackdrop extends StatelessWidget {
  const _HeroBackdrop();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: SizedBox(
                width: 380,
                height: 380,
                child: CustomPaint(painter: _HalftonePainter()),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-1.05, 0.55),
            child: Opacity(
              opacity: 0.10,
              child: Transform.rotate(
                angle: -0.3,
                child: SvgPicture.asset(
                  'assets/svg/squiggle.svg',
                  width: 220,
                  colorFilter: const ColorFilter.mode(_paper, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(-0.22, -0.74),
            child: Opacity(
              opacity: 0.9,
              child: SvgPicture.asset(
                'assets/svg/sparkle.svg',
                width: 30,
                height: 30,
                colorFilter: const ColorFilter.mode(
                  AppColors.blue,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.02, 0.18),
            child: Opacity(
              opacity: 0.35,
              child: SvgPicture.asset(
                'assets/svg/sparkle.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(_paper, BlendMode.srcIn),
              ),
            ),
          ),
          for (final a in const [
            Alignment(-0.96, -0.45),
            Alignment(0.97, 0.38),
            Alignment(0.1, 0.82),
          ])
            Align(
              alignment: a,
              child: Icon(
                Icons.add_rounded,
                size: 16,
                color: _paper.withValues(alpha: 0.22),
              ),
            ),
        ],
      ),
    );
  }
}

class _HalftonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const gap = 14.0;
    final paint = Paint()..color = AppColors.blue.withValues(alpha: 0.4);
    final rows = (size.height / gap).floor();
    final cols = (size.width / gap).floor();
    for (int r = 0; r <= rows; r++) {
      for (int c = 0; c <= cols; c++) {
        final x = c * gap + (r.isOdd ? gap / 2 : 0);
        final y = r * gap;
        // strongest top-right, fading to nothing bottom-left
        final t = ((x / size.width) + (1 - y / size.height)) / 2;
        final radius = 4.2 * math.pow(t.clamp(0.0, 1.0), 1.7);
        if (radius < 0.6) continue;
        canvas.drawCircle(Offset(x, y), radius.toDouble(), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ────────────────────────────────────────────────────────────────────
//  TAPE STRIP — tilted paper band, scrolling marquee (seamless loop)
//  Sits at the bottom of the hero and separates it from the next section.
// ────────────────────────────────────────────────────────────────────

class _TapeStrip extends StatefulWidget {
  const _TapeStrip();

  @override
  State<_TapeStrip> createState() => _TapeStripState();
}

class _TapeStripState extends State<_TapeStrip>
    with SingleTickerProviderStateMixin {
  static const _label =
      'REELS   ✦   YOUTUBE EDITS   ✦   CONTENT PACKAGING   ✦   ';

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 22),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = AppText.body(
      size: 13,
      weight: FontWeight.w800,
      color: _paperInk,
    ).copyWith(letterSpacing: 3);

    // Width of ONE repeat. Translating by exactly this width makes a
    // seamless loop.
    final unitW = (TextPainter(
      text: TextSpan(text: _label, style: style),
      textDirection: TextDirection.ltr,
    )..layout()).width;

    return SizedBox(
      height: 64,
      child: Center(
        child: Transform.rotate(
          angle: -0.012,
          child: Transform.scale(
            scaleX: 1.1,
            child: Container(
              height: 38,
              color: _paper,
              alignment: Alignment.centerLeft,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  minWidth: 0,
                  maxWidth: double.infinity,
                  child: AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, child) {
                      final t = context.reduceMotion ? 0.0 : _ctrl.value;
                      return Transform.translate(
                        offset: Offset(-unitW * t, 0),
                        child: child,
                      );
                    },
                    child: Text(
                      _label * 16,
                      softWrap: false,
                      maxLines: 1,
                      style: style,
                    ),
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
//  HEADLINE COPY
// ────────────────────────────────────────────────────────────────────

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onNavigate, this.alignLeft = false});

  final void Function(String id) onNavigate;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    final titleSize = context.responsive(
      mobile: 40.0,
      tablet: alignLeft ? 50.0 : 58.0,
      desktop: alignLeft ? 58.0 : 72.0,
    );

    final crossAlign = alignLeft
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.center;
    final textAlign = alignLeft ? TextAlign.left : TextAlign.center;
    final wrapAlign = alignLeft ? WrapAlignment.start : WrapAlignment.center;

    return Column(
      crossAxisAlignment: crossAlign,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Reveal(child: _Availability()),
        const SizedBox(height: 20),
        Reveal(
          delay: const Duration(milliseconds: 100),
          child: Semantics(
            header: true,
            child: _Headline(size: titleSize, alignLeft: alignLeft),
          ),
        ),
        const SizedBox(height: 20),
        Reveal(
          delay: const Duration(milliseconds: 200),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: alignLeft ? 460 : 600),
            child: Text(
              'High-retention Reels, viral YouTube edits, and cinematic '
              'content packaging for top creators who refuse to blend in.',
              textAlign: textAlign,
              style: AppText.body(
                size: context.responsive(mobile: 15.0, desktop: 16.5),
                color: Colors.white60,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Reveal(
          delay: const Duration(milliseconds: 250),
          child: _Tagline(alignment: wrapAlign),
        ),
        const SizedBox(height: 22),
        Reveal(
          delay: const Duration(milliseconds: 300),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: wrapAlign,
            children: [
              AppButton(
                label: 'See my work',
                arrow: true,
                variant: ButtonVariant.blue,
                onPressed: () => onNavigate('work'),
              ),
              AppButton(
                label: "Let's talk",
                variant: ButtonVariant.ghost,
                onDark: true,
                onPressed: () => onNavigate('contact'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Reveal(
          delay: const Duration(milliseconds: 400),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: alignLeft ? 460 : 600),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: _paper.withValues(alpha: 0.16)),
                ),
              ),
              child: Wrap(
                spacing: 32,
                runSpacing: 14,
                alignment: wrapAlign,
                children: const [
                  _Proof('50M+', 'views generated'),
                  _Proof('500+', 'videos edited'),
                  _Proof('20+', 'accounts managed'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  TAGLINE — NO BS. YOUR BRAND, OUR STRATEGY.
// ────────────────────────────────────────────────────────────────────

class _Tagline extends StatelessWidget {
  const _Tagline({required this.alignment});

  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        Transform.rotate(
          angle: -0.04,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
              'NO BS.',
              style: AppText.display(
                size: 16,
                weight: FontWeight.w900,
                color: Colors.white,
                height: 1,
              ).copyWith(letterSpacing: 1.5),
            ),
          ),
        ),
        Text(
          'YOUR BRAND, OUR STRATEGY.',
          style: AppText.body(
            size: 13,
            weight: FontWeight.w800,
            color: _paper,
            height: 1,
          ).copyWith(letterSpacing: 2),
        ),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.size, required this.alignLeft});

  final double size;
  final bool alignLeft;

  @override
  Widget build(BuildContext context) {
    final base = AppText.display(
      size: size,
      height: 1.0,
    ).copyWith(color: Colors.white, letterSpacing: -size * 0.02);
    // One serif-italic word breaks the "all sans" startup look.
    final serif = base.copyWith(
      fontFamily: 'Georgia',
      fontFamilyFallback: const ['Times New Roman', 'serif'],
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
      color: _paper,
      letterSpacing: 0,
    );
    final align = alignLeft ? TextAlign.left : TextAlign.center;

    return Column(
      crossAxisAlignment: alignLeft
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(
          TextSpan(
            style: base,
            children: [
              const TextSpan(text: 'Content\n'),
              TextSpan(text: 'people ', style: serif),
              const TextSpan(text: "can't"),
            ],
          ),
          textAlign: align,
        ),
        const SizedBox(height: 2),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Text('scroll past.', style: base.copyWith(color: AppColors.blue)),
            Positioned(
              left: 0,
              right: 0,
              bottom: -size * 0.14,
              height: size * 0.2,
              child: CustomPaint(painter: _BrushUnderlinePainter()),
            ),
          ],
        ),
        SizedBox(height: size * 0.14),
      ],
    );
  }
}

class _BrushUnderlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final main = Paint()
      ..color = _paper
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;
    final thin = Paint()
      ..color = _paper.withValues(alpha: 0.55)
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

class _Proof extends StatelessWidget {
  const _Proof(this.value, this.label);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value, style: AppText.display(size: 30, height: 1, color: _paper)),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppText.body(size: 13, color: Colors.white54, height: 1),
        ),
      ],
    );
  }
}

class _Availability extends StatefulWidget {
  const _Availability();

  @override
  State<_Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<_Availability>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (_, _) {
              final t = context.reduceMotion ? 0.0 : _pulse.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 8 + 10 * t,
                    height: 8 + 10 * t,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue.withValues(alpha: 0.35 * (1 - t)),
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'TAKING NEW PROJECTS THIS MONTH',
          style: AppText.body(
            size: 12,
            weight: FontWeight.w700,
            color: _paper.withValues(alpha: 0.8),
            height: 1,
          ).copyWith(letterSpacing: 1.8),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  ARC GEOMETRY — shared by painter, nodes and overlays
// ────────────────────────────────────────────────────────────────────

class _ArcGeometry {
  _ArcGeometry(double w, double h, this.isMobile)
    : cx = w / 2,
      spotY = h - 22,
      radius =
          (isMobile
                  ? (w * 0.95).clamp(320.0, 500.0)
                  : (w * 0.9).clamp(520.0, 900.0))
              .toDouble();

  final bool isMobile;
  final double cx;
  final double spotY;
  final double radius;

  double get cy => spotY - radius;

  /// Angle between neighbouring creators.
  double get step => isMobile ? 0.46 : 0.34;

  Offset at(double angle) =>
      Offset(cx + radius * math.sin(angle), cy + radius * math.cos(angle));
}

// ────────────────────────────────────────────────────────────────────
//  CREATOR DIAL
//  auto-advances · drag (mouse/touch) · horizontal wheel · ← → keys · ticks
//  Auto-advance pauses while the pointer is over the dial or dragging.
// ────────────────────────────────────────────────────────────────────

class _ArcDialerSection extends StatefulWidget {
  const _ArcDialerSection();

  @override
  State<_ArcDialerSection> createState() => _ArcDialerSectionState();
}

class _ArcDialerSectionState extends State<_ArcDialerSection>
    with SingleTickerProviderStateMixin {
  static const _autoEvery = Duration(milliseconds: 3200);

  double _position = 0.0;
  int get _activeIndex =>
      _position.round().clamp(0, creators.length - 1).toInt();

  late final AnimationController _snapCtrl;
  double _snapFrom = 0.0;
  double _snapTarget = 0.0;

  final FocusNode _focus = FocusNode();
  Timer? _settle;

  // auto-scroll
  Timer? _auto;
  bool _dragging = false;
  bool _hovering = false;

  @override
  void initState() {
    super.initState();
    _snapCtrl =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 450),
        )..addListener(() {
          setState(() {
            _position =
                _snapFrom +
                (_snapTarget - _snapFrom) *
                    Curves.easeOutCubic.transform(_snapCtrl.value);
          });
        });
    _startAuto();
  }

  @override
  void dispose() {
    _auto?.cancel();
    _settle?.cancel();
    _focus.dispose();
    _snapCtrl.dispose();
    super.dispose();
  }

  void _startAuto() {
    _auto?.cancel();
    if (creators.length < 2) return;
    _auto = Timer.periodic(_autoEvery, (_) {
      if (!mounted || _dragging || _hovering || context.reduceMotion) return;
      _next();
    });
  }

  double get _minPos => -0.35;
  double get _maxPos => creators.length - 0.65;

  void _animateTo(double target) {
    final t = target.clamp(0.0, (creators.length - 1).toDouble()).toDouble();
    final dist = (t - _position).abs();
    _snapFrom = _position;
    _snapTarget = t;
    _snapCtrl.duration = Duration(
      milliseconds: (320 + 110 * dist).round().clamp(320, 760).toInt(),
    );
    _snapCtrl.forward(from: 0);
  }

  void _onDragStart() {
    _dragging = true;
    _snapCtrl.stop();
  }

  void _onDragUpdate(double dx) {
    _snapCtrl.stop();
    setState(() {
      _position = (_position - dx / 170.0).clamp(_minPos, _maxPos).toDouble();
    });
  }

  void _onDragEnd(double velocity) {
    _dragging = false;
    // fling: project forward a little so a quick flick moves further
    final projected = _position - (velocity / 170.0) * 0.22;
    _animateTo(projected.round().clamp(0, creators.length - 1).toDouble());
    _startAuto();
  }

  void _onPointerSignal(PointerSignalEvent e) {
    if (e is! PointerScrollEvent) return;
    // Only horizontal wheel / shift-wheel — vertical wheel keeps scrolling the page.
    if (e.scrollDelta.dx.abs() <= e.scrollDelta.dy.abs()) return;
    _snapCtrl.stop();
    setState(() {
      _position = (_position + e.scrollDelta.dx / 240.0)
          .clamp(_minPos, _maxPos)
          .toDouble();
    });
    _settle?.cancel();
    _settle = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      _animateTo(_position.round().clamp(0, creators.length - 1).toDouble());
    });
  }

  void _selectCreator(int index) {
    _animateTo(index.toDouble());
    _startAuto(); // restart the countdown after a manual pick
  }

  void _next() => _animateTo(((_activeIndex + 1) % creators.length).toDouble());

  void _prev() => _animateTo(
    ((_activeIndex - 1 + creators.length) % creators.length).toDouble(),
  );

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final active = creators[_activeIndex];
    final worksCount = math.min(3, active.works.length);

    return Reveal(
      delay: const Duration(milliseconds: 450),
      child: Focus(
        focusNode: _focus,
        onKeyEvent: (node, event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            _next();
            _startAuto();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            _prev();
            _startAuto();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          onEnter: (_) => _hovering = true,
          onExit: (_) => _hovering = false,
          child: Listener(
            onPointerDown: (_) => _focus.requestFocus(),
            onPointerSignal: _onPointerSignal,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsive(mobile: 4.0, desktop: 12.0),
                  ),
                  child: Column(
                    children: [
                      _buildStage(active, isMobile),
                      _buildProgress(isMobile),
                      if (worksCount > 0)
                        _DoodleArrows(count: worksCount, isMobile: isMobile),
                      const SizedBox(height: 6),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.05),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: _CreatorWorksRow(
                          key: ValueKey(active.name),
                          creator: active,
                          isMobile: isMobile,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Stage: outline name · arc · blob · cutouts · sticker ──
  Widget _buildStage(Creator active, bool isMobile) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = isMobile ? 290.0 : 340.0;
        final g = _ArcGeometry(w, h, isMobile);

        final blobW = isMobile ? 200.0 : 290.0;
        final blobH = isMobile ? 190.0 : 255.0;

        // paint far creators first so the active one is on top
        final order = List<int>.generate(creators.length, (i) => i)
          ..sort(
            (a, b) => (b - _position).abs().compareTo((a - _position).abs()),
          );

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (_) => _onDragStart(),
          onHorizontalDragUpdate: (d) => _onDragUpdate(d.delta.dx),
          onHorizontalDragEnd: (d) => _onDragEnd(d.primaryVelocity ?? 0),
          child: SizedBox(
            width: w,
            height: h,
            child: ClipRect(
              child: Stack(
                children: [
                  // giant outlined name behind everything
                  Positioned(
                    left: 0,
                    right: 0,
                    top: h * 0.06,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        key: ValueKey(active.name),
                        width: w,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _OutlineName(
                            text: active.name,
                            size: isMobile ? 72 : 120,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: CustomPaint(painter: _DottedArcPainter(g)),
                  ),

                  // misregistered blob — turns slightly as the dial moves
                  Positioned(
                    left: g.cx - blobW / 2,
                    top: g.spotY - blobH * 0.95,
                    width: blobW,
                    height: blobH,
                    child: Transform.rotate(
                      angle: _position * 0.5,
                      child: CustomPaint(painter: _BlobPainter()),
                    ),
                  ),

                  for (final i in order)
                    _ArcCreatorNode(
                      creator: creators[i],
                      index: i,
                      position: _position,
                      geometry: g,
                      isMobile: isMobile,
                      onTap: () => _selectCreator(i),
                    ),

                  // name tag stuck over the "hands"
                  Positioned(
                    left: g.cx + (isMobile ? 18 : 40),
                    top: g.spotY - (isMobile ? 54 : 62),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _NameSticker(
                        key: ValueKey(active.name),
                        creator: active,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Progress ticks (tap a tick to jump; no prev/next buttons) ──
  Widget _buildProgress(bool isMobile) {
    final total = creators.length;
    final shown = (_activeIndex + 1).toString().padLeft(2, '0');
    final totalStr = total.toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < total; i++)
          GestureDetector(
            onTap: () => _selectCreator(i),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: i == _activeIndex ? 34 : 16,
                height: 3,
                color: i == _activeIndex
                    ? AppColors.blue
                    : _paper.withValues(alpha: 0.28),
              ),
            ),
          ),
        if (!isMobile) ...[
          const SizedBox(width: 18),
          Text(
            '$shown / $totalStr',
            style: AppText.body(
              size: 12,
              weight: FontWeight.w700,
              color: _paper.withValues(alpha: 0.6),
            ).copyWith(letterSpacing: 1.6),
          ),
        ],
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  DOTTED ARC (thin, cream, fades out at the ends)
// ────────────────────────────────────────────────────────────────────

class _DottedArcPainter extends CustomPainter {
  const _DottedArcPainter(this.g);

  final _ArcGeometry g;

  @override
  void paint(Canvas canvas, Size size) {
    final span = g.step * 2.8;
    final arcLength = g.radius * span * 2;
    final n = (arcLength / 12).floor();
    final paint = Paint();

    for (int i = 0; i <= n; i++) {
      final t = -span + 2 * span * (i / n);
      final norm = (t / span).abs(); // 0 centre → 1 edge
      final alpha = (1.0 - norm * 0.85).clamp(0.05, 1.0);
      paint.color = _paper.withValues(alpha: 0.5 * alpha);
      canvas.drawCircle(g.at(t), 1.6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DottedArcPainter old) =>
      old.g.cx != g.cx || old.g.spotY != g.spotY || old.g.radius != g.radius;
}

// ────────────────────────────────────────────────────────────────────
//  BLOB — flat brand blue + cream outline shifted off-register
// ────────────────────────────────────────────────────────────────────

class _BlobPainter extends CustomPainter {
  static const _r = [0.96, 0.86, 1.0, 0.9, 0.97, 0.84, 1.0, 0.92];

  Path _path(Size s, Offset shift) {
    final n = _r.length;
    final c = s.center(Offset.zero) + shift;
    final base = math.min(s.width, s.height) / 2;

    final pts = <Offset>[
      for (int i = 0; i < n; i++)
        Offset(
          c.dx + math.cos(2 * math.pi * i / n) * base * _r[i] * 1.05,
          c.dy + math.sin(2 * math.pi * i / n) * base * _r[i],
        ),
    ];

    Offset mid(Offset a, Offset b) =>
        Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);

    final start = mid(pts.last, pts.first);
    final path = Path()..moveTo(start.dx, start.dy);
    for (int i = 0; i < n; i++) {
      final m = mid(pts[i], pts[(i + 1) % n]);
      path.quadraticBezierTo(pts[i].dx, pts[i].dy, m.dx, m.dy);
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _path(size, const Offset(12, 10)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = _paper.withValues(alpha: 0.5),
    );
    canvas.drawPath(_path(size, Offset.zero), Paint()..color = AppColors.blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ────────────────────────────────────────────────────────────────────
//  OUTLINED GIANT NAME
// ────────────────────────────────────────────────────────────────────

class _OutlineName extends StatelessWidget {
  const _OutlineName({required this.text, required this.size});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    final base = AppText.display(size: size, height: 0.9);
    return Text(
      text.toUpperCase(),
      maxLines: 1,
      softWrap: false,
      style: TextStyle(
        fontFamily: base.fontFamily,
        fontFamilyFallback: base.fontFamilyFallback,
        fontSize: size,
        fontWeight: FontWeight.w900,
        height: 0.9,
        letterSpacing: -size * 0.02,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..color = _paper.withValues(alpha: 0.22),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  CUTOUT CREATOR ON THE ARC
// ────────────────────────────────────────────────────────────────────

class _ArcCreatorNode extends StatelessWidget {
  const _ArcCreatorNode({
    required this.creator,
    required this.index,
    required this.position,
    required this.geometry,
    required this.isMobile,
    required this.onTap,
  });

  final Creator creator;
  final int index;
  final double position;
  final _ArcGeometry geometry;
  final bool isMobile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final diff = index - position;
    final ad = diff.abs();
    if (ad > 2.7) return const SizedBox.shrink();

    final angle = diff * geometry.step;
    final p = geometry.at(angle);

    // 1 in the spot → 0 one slot away
    final t = Curves.easeOut.transform((1 - ad).clamp(0.0, 1.0));
    final activeH = isMobile ? 195.0 : 250.0;
    final idleH = isMobile ? 80.0 : 110.0;
    final hgt = lerpDouble(idleH, activeH, t)!;

    final opacity = ad < 1.7 ? 1.0 : (1 - (ad - 1.7)).clamp(0.0, 1.0);
    final shade = const Color(0xFF0B1118).withValues(alpha: 0.55 * (1 - t));

    return Positioned(
      left: p.dx - hgt / 2,
      top: p.dy - hgt,
      width: hgt,
      height: hgt,
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Opacity(
            opacity: opacity.toDouble(),
            child: Transform.rotate(
              // lean toward the arc's centre, like standing on a wheel
              angle: -angle * 0.7,
              alignment: Alignment.bottomCenter,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(shade, BlendMode.srcATop),
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (rect) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white, Colors.transparent],
                    stops: [0.0, 0.82, 1.0],
                  ).createShader(rect),
                  child: _CutoutImage(creator: creator),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CutoutImage extends StatelessWidget {
  const _CutoutImage({required this.creator});

  final Creator creator;

  @override
  Widget build(BuildContext context) {
    final src = creator.cutout ?? creator.avatarUrl;
    if (src != null && src.isNotEmpty) {
      return Image.asset(
        src,
        fit: BoxFit.contain,
        alignment: Alignment.bottomCenter,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, __, ___) => _fallbackAvatar(),
      );
    }

    // Placeholder until the real cutout PNG is added.
    return _fallbackAvatar();
  }

  Widget _fallbackAvatar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.85,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1B2733),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(200),
              topRight: Radius.circular(200),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            creator.name.isEmpty ? '?' : creator.name[0],
            style: AppText.display(size: 44, color: _paper),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  NAME STICKER — paper label with hard offset shadow
// ────────────────────────────────────────────────────────────────────

class _NameSticker extends StatelessWidget {
  const _NameSticker({super.key, required this.creator});

  final Creator creator;

  @override
  Widget build(BuildContext context) {
    final hasSvg = creator.svgAsset != null && creator.svgAsset!.isNotEmpty;

    return Transform.rotate(
      angle: 0.05,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 16, 10),
        decoration: BoxDecoration(
          color: _paper,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasSvg)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: SvgPicture.asset(creator.svgAsset!, height: 22),
              ),
            Text(
              creator.name,
              style: AppText.display(
                size: 18,
                weight: FontWeight.w800,
                color: _paperInk,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              creator.handle,
              style: AppText.body(
                size: 12,
                weight: FontWeight.w700,
                color: AppColors.blue,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              creator.role.toUpperCase(),
              style: AppText.body(
                size: 9,
                weight: FontWeight.w800,
                color: _paperInk.withValues(alpha: 0.6),
                height: 1,
              ).copyWith(letterSpacing: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────
//  HAND-DRAWN ARROWS from the spot down to the works
// ────────────────────────────────────────────────────────────────────

class _DoodleArrows extends StatelessWidget {
  const _DoodleArrows({required this.count, required this.isMobile});

  final int count;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: isMobile ? 38 : 46,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _DoodleArrowsPainter(count: count, isMobile: isMobile),
            ),
          ),
          Align(
            alignment: Alignment(isMobile ? 0.45 : 0.28, 0.0),
            child: Transform.rotate(
              angle: -0.07,
              child: Text(
                'their latest cuts',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontFamilyFallback: const ['Times New Roman', 'serif'],
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                  color: _paper.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoodleArrowsPainter extends CustomPainter {
  const _DoodleArrowsPainter({required this.count, required this.isMobile});

  final int count;
  final bool isMobile;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final start = Offset(size.width / 2, 2);
    final h = size.height;
    final arrows = isMobile ? 1 : count;

    for (int i = 0; i < arrows; i++) {
      final endX = isMobile ? size.width / 2 : size.width * (i + 0.5) / count;
      final end = Offset(endX, h - 4);
      final dx = end.dx - start.dx;
      final wob = i.isEven ? 12.0 : -12.0;

      final c1 = Offset(start.dx + dx * 0.1 + wob, h * 0.45);
      final c2 = Offset(end.dx - dx * 0.05 - wob, h * 0.65);

      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);

      // open "V" arrowhead, like a pen stroke
      final dir = math.atan2(end.dy - c2.dy, end.dx - c2.dx);
      for (final s in const [-1.0, 1.0]) {
        final a = dir + math.pi + s * 0.55;
        canvas.drawLine(
          end,
          end + Offset(math.cos(a), math.sin(a)) * 11,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DoodleArrowsPainter old) =>
      old.count != count || old.isMobile != isMobile;
}

// ────────────────────────────────────────────────────────────────────
//  WORKS — paper cards with tape, slight tilt, hard shadow
//  Thumbnail + view count only. Always laid out in ONE row (compact
//  on mobile) so they sit right under the creator.
// ────────────────────────────────────────────────────────────────────

class _CreatorWorksRow extends StatelessWidget {
  const _CreatorWorksRow({
    super.key,
    required this.creator,
    required this.isMobile,
  });

  final Creator creator;
  final bool isMobile;

  static const _tilts = [-0.018, 0.012, -0.01];

  @override
  Widget build(BuildContext context) {
    final works = creator.works;
    final count = math.min(3, works.length);
    final gap = isMobile ? 10.0 : 16.0;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < count; i++) ...[
            if (i > 0) SizedBox(width: gap),
            Expanded(
              child: _ArcWorkCard(
                work: works[i],
                index: i + 1,
                compact: isMobile,
                tilt: isMobile ? _tilts[i] * 0.5 : _tilts[i],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ArcWorkCard extends StatefulWidget {
  const _ArcWorkCard({
    required this.work,
    required this.index,
    required this.compact,
    required this.tilt,
  });

  final CreatorWork work;
  final int index;
  final bool compact;
  final double tilt;

  @override
  State<_ArcWorkCard> createState() => _ArcWorkCardState();
}

class _ArcWorkCardState extends State<_ArcWorkCard> {
  bool _hover = false;

  static const _gradients = [
    [Color(0xFF2596BE), Color(0xFF0F4C63)],
    [Color(0xFF16213E), Color(0xFF0F3460)],
    [Color(0xFF533483), Color(0xFF1A1A2E)],
    [Color(0xFF0A2647), Color(0xFF144272)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[widget.work.colorSeed % _gradients.length];
    final compact = widget.compact;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            transformAlignment: Alignment.center,
            transform: Matrix4.translationValues(0, _hover ? -6 : 0, 0)
              ..rotateZ(_hover ? 0.0 : widget.tilt),
            padding: EdgeInsets.all(compact ? 5 : 8),
            decoration: BoxDecoration(
              color: _paper,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: _hover
                      ? AppColors.blue
                      : Colors.black.withValues(alpha: 0.5),
                  offset: _hover ? const Offset(6, 6) : const Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // thumbnail only
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    height: compact ? 76 : 104,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                    ),
                  ),
                ),
                // views only
                Padding(
                  padding: EdgeInsets.fromLTRB(4, compact ? 8 : 10, 4, 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility_rounded,
                        size: 13,
                        color: _paperInk.withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          widget.work.metric,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.body(
                            size: compact ? 12 : 13,
                            weight: FontWeight.w800,
                            color: _paperInk,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // strip of tape on top of the card
          Positioned(
            top: -8,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: Transform.rotate(
                  angle: 0.05,
                  child: Container(
                    width: compact ? 40 : 54,
                    height: 16,
                    color: AppColors.blue.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
