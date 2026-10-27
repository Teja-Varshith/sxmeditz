import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'sections/about.dart';
import 'sections/contact.dart';
import 'sections/faq.dart';
import 'sections/footer.dart';
import 'sections/header.dart';
import 'sections/hero.dart';
import 'sections/packages.dart';
import 'sections/process.dart';
import 'sections/reviews.dart';
import 'sections/services.dart';
import 'sections/work.dart';
import 'theme.dart';

void main() {
  // Faster visibility checks so scroll reveals feel immediate.
  VisibilityDetectorController.instance.updateInterval = const Duration(
    milliseconds: 80,
  );
  runApp(const SxmEditxApp());
}

class SxmEditxApp extends StatelessWidget {
  const SxmEditxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SXM.EDITX_',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scroll = ScrollController();
  final _sections = {
    for (final id in [
      'top',
      'work',
      'services',
      'process',
      'reviews',
      'faq',
      'contact',
    ])
      id: GlobalKey(),
  };
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final scrolled = _scroll.offset > 12;
      if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _navigate(String id) {
    final ctx = _sections[id]?.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox;
    final target = id == 'top'
        ? 0.0
        : _scroll.offset +
              box.localToGlobal(Offset.zero).dy -
              SiteHeader.height +
              1;
    _scroll.animateTo(
      target.clamp(0, _scroll.position.maxScrollExtent),
      duration: context.reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget anchor(String id, Widget child) =>
        KeyedSubtree(key: _sections[id], child: child);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MobileMenu(onNavigate: _navigate),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scroll,
            child: Column(
              children: [
                anchor('top', HeroSection(onNavigate: _navigate)),
                const AboutSection(),
                anchor('work', const WorkSection()),
                anchor('services', const ServicesSection()),
                anchor('process', ProcessSection(onNavigate: _navigate)),
                anchor('reviews', const ReviewsSection()),
                PackagesSection(onNavigate: _navigate),
                anchor('faq', FaqSection(onNavigate: _navigate)),
                anchor('contact', const ContactSection()),
                SiteFooter(onNavigate: _navigate),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SiteHeader(
              scrolled: _scrolled,
              onNavigate: _navigate,
              onMenu: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ),
        ],
      ),
    );
  }
}
