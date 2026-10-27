import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import 'common.dart';

/// High-performance cinematic awake & splash screen for SXM.EDITX.
/// Runs an interactive 5 to 8 second loading and asset preparation sequence.
class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onComplete,
    this.duration = const Duration(milliseconds: 6500),
  });

  final VoidCallback onComplete;
  final Duration duration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _pulseController;
  late final AnimationController _waveController;
  late final AnimationController _exitController;

  Timer? _safetyTimeoutTimer;
  bool _isExiting = false;

  final List<(double, String)> _loadingMilestones = const [
    (0.00, 'Initializing creative engine...'),
    (0.18, 'Importing 4K timeline & sequence...'),
    (0.42, 'Syncing beat drops & dynamic cuts...'),
    (0.68, 'Color grading & high-CTR thumbnail render...'),
    (0.88, 'Finalizing audio & motion graphics...'),
    (1.00, 'Ready to build content that converts.'),
  ];

  String _currentStatus = 'Initializing creative engine...';

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _progressController.addListener(_onProgressUpdate);
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _finishAndExit();
      }
    });

    // Start progress
    _progressController.forward();

    // 8-second strict safety timeout
    _safetyTimeoutTimer = Timer(const Duration(seconds: 8), () {
      if (mounted && !_isExiting) {
        _finishAndExit();
      }
    });
  }

  void _onProgressUpdate() {
    final val = _progressController.value;
    for (final milestone in _loadingMilestones) {
      if (val >= milestone.$1) {
        if (_currentStatus != milestone.$2) {
          setState(() {
            _currentStatus = milestone.$2;
          });
        }
      }
    }
  }

  void _finishAndExit() {
    if (_isExiting) return;
    _isExiting = true;
    _safetyTimeoutTimer?.cancel();
    _exitController.forward().then((_) {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _safetyTimeoutTimer?.cancel();
    _progressController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _exitController,
      builder: (context, child) {
        final exitValue = _exitController.value;
        final opacity = (1.0 - exitValue).clamp(0.0, 1.0);
        final scale = 1.0 + (exitValue * 0.08);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.ink,
        body: Stack(
          children: [
            // Ambient animated background glow
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  final glowRadius = 0.6 + (_pulseController.value * 0.25);
                  return Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.0, -0.2),
                        radius: glowRadius,
                        colors: [
                          AppColors.blue.withValues(alpha: 0.18),
                          AppColors.ink.withValues(alpha: 0.8),
                          AppColors.ink,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Top bar with Live badge & Skip button
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Brand mark mini
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SXM STUDIO // 2026',
                          style: AppText.body(
                            size: 11,
                            weight: FontWeight.w700,
                            color: Colors.white54,
                          ).copyWith(letterSpacing: 2.0),
                        ),
                      ],
                    ),

                    // Skip action button
                    TextButton.icon(
                      onPressed: _finishAndExit,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        backgroundColor: Colors.white.withValues(alpha: 0.06),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.fast_forward_rounded,
                        size: 16,
                        color: AppColors.blue,
                      ),
                      label: Text(
                        'SKIP',
                        style: AppText.body(
                          size: 11,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ).copyWith(letterSpacing: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main center focal element
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Glowing Center Logo Box
                      _CenterLogoBadge(pulseController: _pulseController),
                      const SizedBox(height: 36),

                      // Animated Percentage Number
                      AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, _) {
                          final pct = (_progressController.value * 100).toInt();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '$pct',
                                style: AppText.display(
                                  size: context.responsive(
                                    mobile: 52.0,
                                    desktop: 68.0,
                                  ),
                                  weight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1,
                                ),
                              ),
                              Text(
                                '%',
                                style: AppText.display(
                                  size: 26,
                                  weight: FontWeight.w700,
                                  color: AppColors.blue,
                                  height: 1,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      // Video timeline progress bar
                      _TimelineProgressBar(
                        progressController: _progressController,
                      ),

                      const SizedBox(height: 24),

                      // Dynamic Creative Status message
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _currentStatus,
                          key: ValueKey(_currentStatus),
                          textAlign: TextAlign.center,
                          style: AppText.body(
                            size: context.responsive(
                              mobile: 14.0,
                              desktop: 16.0,
                            ),
                            weight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Pulsing Audio Waveform Visualizer
                      _AudioWaveform(waveController: _waveController),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom metadata info
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(
                child: Text(
                  'VIDEO EDITING • THUMBNAILS • SOCIAL GROWTH',
                  style: AppText.body(
                    size: 11,
                    weight: FontWeight.w600,
                    color: Colors.white30,
                  ).copyWith(letterSpacing: 2.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterLogoBadge extends StatelessWidget {
  const _CenterLogoBadge({required this.pulseController});

  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final glowAlpha = 0.2 + (pulseController.value * 0.35);
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.blue.withValues(alpha: 0.8),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.blue.withValues(alpha: glowAlpha),
                blurRadius: 36,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Center(child: LogoMark(size: 44)),
        );
      },
    );
  }
}

class _TimelineProgressBar extends StatelessWidget {
  const _TimelineProgressBar({required this.progressController});

  final AnimationController progressController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedBuilder(
        animation: progressController,
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final fillWidth = constraints.maxWidth * progressController.value;
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: fillWidth,
                  height: 6,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF0F4C63),
                        AppColors.blue,
                        Color(0xFF7BE5FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.6),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AudioWaveform extends StatelessWidget {
  const _AudioWaveform({required this.waveController});

  final AnimationController waveController;

  static const List<double> _baseHeights = [
    12,
    24,
    18,
    32,
    14,
    28,
    40,
    22,
    34,
    16,
    26,
    38,
    20,
    30,
    14,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: waveController,
      builder: (context, _) {
        final phase = waveController.value * 2 * math.pi;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_baseHeights.length, (index) {
            final wave = (math.sin(phase + (index * 0.45)) + 1) / 2;
            final dynamicHeight =
                8 + (_baseHeights[index] * 0.6 * (0.4 + wave * 0.6));

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              width: 3.5,
              height: dynamicHeight,
              decoration: BoxDecoration(
                color: index == 6 || index == 7
                    ? AppColors.blue
                    : AppColors.blue.withValues(alpha: 0.35 + (wave * 0.4)),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
