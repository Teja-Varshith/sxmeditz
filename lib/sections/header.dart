import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/common.dart';

/// Nav targets shown in the header, in order.
const navItems = ['Work', 'Services', 'Process', 'Reviews', 'FAQ'];

class SiteHeader extends StatelessWidget {
  const SiteHeader({
    super.key,
    required this.scrolled,
    required this.onNavigate,
    required this.onMenu,
  });

  static const height = 80.0;

  final bool scrolled;
  final void Function(String id) onNavigate;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    // Switch to hamburger earlier so nav links don't get crushed.
    final compact = context.screenWidth < 960;

    // Floating pill: inset from the edges, rounded, shadowed. It stays
    // transparent-looking over the hero and gains a solid surface on scroll.
    return SizedBox(
      height: height,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Breakpoints.maxContent),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive(
                mobile: 12.0,
                tablet: 20.0,
                desktop: 28.0,
              ),
              vertical: 5,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.line),
                boxShadow: scrolled
                    ? [
                        BoxShadow(
                          color: AppColors.ink.withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : const [],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo — fixed min-size so it never gets squished.
                  Semantics(
                    button: true,
                    label: 'SXM.EDITX home',
                    child: InkWell(
                      onTap: () => onNavigate('top'),
                      borderRadius: BorderRadius.circular(8),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LogoMark(size: 32),
                          SizedBox(width: 10),
                          Wordmark(size: 18),
                        ],
                      ),
                    ),
                  ),
                  if (compact) ...[
                    const Spacer(),
                    IconButton(
                      tooltip: 'Menu',
                      onPressed: onMenu,
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: AppColors.ink,
                        size: 28,
                      ),
                    ),
                  ] else ...[
                    const Spacer(),
                    // Nav links – shrink-wrap so they never fight the logo.
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final item in navItems)
                          _NavLink(item, () => onNavigate(item.toLowerCase())),
                        const SizedBox(width: 12),
                        AppButton(
                          label: 'Book a call',
                          small: true,
                          onPressed: () => onNavigate('contact'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (v) => setState(() => _hover = v),
        hoverColor: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: AppText.body(
                size: 15,
                weight: FontWeight.w600,
                color: AppColors.ink,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              width: _hover ? 20 : 0,
              color: AppColors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

/// Mobile slide-out menu.
class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key, required this.onNavigate});

  final void Function(String id) onNavigate;

  @override
  Widget build(BuildContext context) {
    void go(String id) {
      Navigator.of(context).pop();
      onNavigate(id);
    }

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Wordmark(size: 20),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Close menu',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: AppColors.ink),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              for (final item in navItems)
                InkWell(
                  onTap: () => go(item.toLowerCase()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      item,
                      style: AppText.display(size: 34, weight: FontWeight.w700),
                    ),
                  ),
                ),
              const Spacer(),
              AppButton(
                label: 'Book a call',
                arrow: true,
                expand: true,
                onPressed: () => go('contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
