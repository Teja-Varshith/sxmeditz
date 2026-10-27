import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:sam_editz/main.dart';

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  // Renders the full page at each size; layout overflows fail the test.
  for (final size in const [Size(1440, 900), Size(820, 1180), Size(390, 844)]) {
    testWidgets('home page lays out at ${size.width.toInt()}px', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const SxmEditxApp());
      await tester.pump(const Duration(seconds: 2));

      expect(find.textContaining('Content people'), findsOneWidget);
      expect(
        find.text('Made to be watched.', findRichText: true),
        findsOneWidget,
      );
    });
  }
}
