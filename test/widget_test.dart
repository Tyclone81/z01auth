import 'package:flutter_test/flutter_test.dart';
import 'package:z01auth/features/auth/widgets/proximity_shield_hero.dart';
import 'package:z01auth/main.dart';

void main() {
  testWidgets('Z01AuthApp loads and displays auth screen with Lock & Shield centerpiece', (WidgetTester tester) async {
    await tester.pumpWidget(const Z01AuthApp());
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Brand Title & Subtitle
    expect(find.text('Z01 Authentication App'), findsOneWidget);
    expect(find.text('ZONE01 KISUMU'), findsOneWidget);

    // Verify Proximity Shield Hero is present
    expect(find.byType(ProximityShieldHero), findsOneWidget);

    // Verify Initial In-Range State
    expect(find.text('On premises · 18 m'), findsOneWidget);
    expect(find.text('Wi-Fi verified'), findsOneWidget);
    expect(find.text('Biometrics ready'), findsOneWidget);
    expect(find.text('Sign in with biometrics'), findsOneWidget);

    // Tap the Proximity Shield Hero to toggle proximity gate simulation
    await tester.tap(find.byType(ProximityShieldHero));
    await tester.pump(const Duration(milliseconds: 400));

    // Verify Gated / Locked State
    expect(find.text('Off premises · >150 m'), findsWidgets);
    expect(find.text('Wi-Fi not detected'), findsOneWidget);
    expect(find.text('Biometrics locked'), findsOneWidget);
    expect(find.text('Biometrics unlock on campus'), findsOneWidget);

    // Tap again to toggle back
    await tester.tap(find.byType(ProximityShieldHero));
    await tester.pump(const Duration(milliseconds: 400));

    // Verify restored In-Range State
    expect(find.text('On premises · 18 m'), findsWidgets);
    expect(find.text('Wi-Fi verified'), findsOneWidget);
    expect(find.text('Biometrics ready'), findsOneWidget);
    expect(find.text('Sign in with biometrics'), findsOneWidget);

    // Test Theme toggle button
    final themeToggleFinder = find.byTooltip('Toggle theme');
    expect(themeToggleFinder, findsOneWidget);
    await tester.tap(themeToggleFinder);
    await tester.pump(const Duration(milliseconds: 300));
  });
}
