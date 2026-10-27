import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../theme.dart';

Future<void> openUrl(String url) =>
    launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');

// ---------------------------------------------------------------- Layout

/// Full-width band with centred, max-width content and responsive gutters.
class Section extends StatelessWidget {
  const Section({super.key, required this.child, this.color, this.vertical});

  final Widget child;
  final Color? color;
  final double? vertical;

  @override
  Widget build(BuildContext context) {
    final v = vertical ?? context.responsive(mobile: 80.0, desktop: 120.0);
    return Container(
      width: double.infinity,
      color: color,
      padding: EdgeInsets.symmetric(vertical: v),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Breakpoints.maxContent),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive(
                mobile: 16.0,
                tablet: 32.0,
                desktop: 40.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Motion

/// Fades and slides its child in the first time it scrolls into view.
class Reveal extends StatefulWidget {
  const Reveal({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> {
  final _key = UniqueKey();
  bool _visible = false;

  void _onVisibility(VisibilityInfo info) {
    if (_visible) return;
    if (info.visibleFraction > 0.15 || info.visibleBounds.height > 120) {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _visible = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return widget.child;
    const duration = Duration(milliseconds: 750);
    const curve = Curves.easeOutCubic;
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: _onVisibility,
      child: AnimatedOpacity(
        opacity: _visible ? 1 : 0,
        duration: duration,
        curve: curve,
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, 0.08),
          duration: duration,
          curve: curve,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Endlessly scrolling horizontal row. Pauses on hover.
class Marquee extends StatefulWidget {
  const Marquee({
    super.key,
    required this.children,
    required this.height,
    this.speed = 60,
    this.gap = 40,
    this.reverse = false,
  });

  final List<Widget> children;
  final double height;

  /// Pixels per second.
  final double speed;
  final double gap;
  final bool reverse;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  final _controller = ScrollController();
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    if (_paused ||
        !_controller.hasClients ||
        !_controller.position.hasContentDimensions ||
        context.reduceMotion) {
      return;
    }
    _controller.jumpTo(_controller.offset + widget.speed * dt);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.children.length;
    return MouseRegion(
      onEnter: (_) => _paused = true,
      onExit: (_) => _paused = false,
      child: SizedBox(
        height: widget.height,
        child: ListView.builder(
          controller: _controller,
          reverse: widget.reverse,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) => Padding(
            padding: EdgeInsets.only(right: widget.gap),
            child: Center(child: widget.children[i % n]),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Brand

class LogoMark extends StatelessWidget {
  const LogoMark({super.key, this.size = 36});

  final double size;

  /// PLACEHOLDER logo — swap for Image.asset('assets/logo.png') later.
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: size * 0.18,
            top: size * 0.28,
            bottom: size * 0.28,
            child: Container(
              width: size * 0.08,
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: size * 0.12),
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: size * 0.7,
            ),
          ),
        ],
      ),
    );
  }
}

class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 20, this.color = AppColors.ink});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'SXM'),
          TextSpan(
            text: '.',
            style: TextStyle(color: AppColors.blue),
          ),
          const TextSpan(text: 'EDITX'),
        ],
      ),
      style: AppText.display(size: size, color: color, height: 1),
    );
  }
}

// ---------------------------------------------------------------- Typography

class Kicker extends StatelessWidget {
  const Kicker(this.text, {super.key, this.light = false});

  final String text;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text.toUpperCase(),
            style: AppText.body(
              size: 13,
              weight: FontWeight.w700,
              color: light ? AppColors.blue : AppColors.blueInk,
            ).copyWith(letterSpacing: 1.6),
          ),
        ],
      ),
    );
  }
}

/// Large heading where [highlight] (appended after [text]) is set in brand blue.
class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.text, {
    super.key,
    this.highlight,
    this.color = AppColors.ink,
    this.size,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final String? highlight;
  final Color color;
  final double? size;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final s =
        size ?? context.responsive(mobile: 36.0, tablet: 46.0, desktop: 56.0);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text),
          if (highlight != null)
            TextSpan(
              text: highlight,
              style: const TextStyle(color: AppColors.blue),
            ),
        ],
      ),
      textAlign: textAlign,
      style: AppText.display(size: s, color: color),
    );
  }
}

// ---------------------------------------------------------------- Buttons

enum ButtonVariant { primary, ghost, blue }

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.arrow = false,
    this.small = false,
    this.expand = false,
    this.onDark = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool arrow;
  final bool small;
  final bool expand;
  final bool onDark;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, Color border) = switch (widget.variant) {
      ButtonVariant.primary =>
        _hover
            ? (AppColors.blue, AppColors.ink, AppColors.blue)
            : (AppColors.ink, Colors.white, AppColors.ink),
      ButtonVariant.blue =>
        _hover
            ? (Colors.white, AppColors.ink, Colors.white)
            : (AppColors.blue, AppColors.ink, AppColors.blue),
      ButtonVariant.ghost =>
        widget.onDark
            ? (_hover
                  ? (Colors.white, AppColors.ink, Colors.white)
                  : (Colors.transparent, Colors.white, Colors.white38))
            : (_hover
                  ? (AppColors.ink, Colors.white, AppColors.ink)
                  : (Colors.transparent, AppColors.ink, AppColors.line)),
    };

    final content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: AppText.body(
            size: widget.small ? 14 : 16,
            weight: FontWeight.w700,
            color: fg,
            height: 1,
          ),
        ),
        if (widget.arrow) ...[
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.only(left: _hover ? 14 : 8),
            child: Icon(Icons.arrow_forward_rounded, size: 18, color: fg),
          ),
        ],
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (v) => setState(() => _hover = v),
        onFocusChange: (v) => setState(() => _hover = v),
        borderRadius: BorderRadius.circular(100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.small ? 18 : 26,
            vertical: widget.small ? 12 : 18,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: border, width: 1.5),
          ),
          child: content,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Media

/// Shows [image] if provided, otherwise a branded gradient placeholder.
class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({
    super.key,
    required this.variant,
    this.label,
    this.image,
    this.showPlay = false,
    this.radius = 18,
  });

  final int variant;
  final String? label;
  final String? image;
  final bool showPlay;
  final double radius;

  static const _gradients = [
    [Color(0xFF2596BE), Color(0xFF0F4C63)],
    [Color(0xFF111111), Color(0xFF2E2E2E)],
    [Color(0xFFE8F4F9), Color(0xFFB9DFEE)],
    [Color(0xFF1A1A1A), Color(0xFF2596BE)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[variant % _gradients.length];
    final lightBg = variant % _gradients.length == 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (image != null)
            Image.asset(image!, fit: BoxFit.cover)
          else ...[
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                ),
              ),
            ),
            // Subtle decorative shape so placeholders don't feel flat.
            Positioned(
              right: -40,
              bottom: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (lightBg ? AppColors.blue : Colors.white).withValues(
                    alpha: 0.12,
                  ),
                ),
              ),
            ),
            if (label != null)
              Positioned(
                left: 14,
                top: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: lightBg
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    label!.toUpperCase(),
                    style: AppText.body(
                      size: 11,
                      weight: FontWeight.w700,
                      color: lightBg ? AppColors.blueInk : Colors.white,
                      height: 1,
                    ).copyWith(letterSpacing: 1.2),
                  ),
                ),
              ),
          ],
          if (showPlay)
            Center(
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.ink,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Lifts slightly on hover.
class HoverLift extends StatefulWidget {
  const HoverLift({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          offset: _hover ? const Offset(0, -0.015) : Offset.zero,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            scale: _hover ? 1.015 : 1,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
