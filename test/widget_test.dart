import 'package:flutter_test/flutter_test.dart';
import 'package:z01auth/features/auth/widgets/proximity_shield_hero.dart';
import 'package:z01auth/main.dart';

void main() {
  testWidgets('Z01AuthApp loads and displays auth screen with Lock & Shield centerpiece', (WidgetTester tester) async {
    await tester.pumpWidget(const Z01AuthApp());
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Brand Title
    expect(find.text('Z01auth'), findsOneWidget);

    // Verify Proximity Shield Hero is present
    expect(find.byType(ProximityShieldHero), findsOneWidget);

    // Verify Initial In-Range State
    expect(find.text('Campus Gate Unlocked'), findsOneWidget);
    expect(find.text('ZONE01 HUB • 18m IN RANGE'), findsOneWidget);
    expect(find.text('Z01_Campus_5G'), findsOneWidget);
    expect(find.text('Biometrics Armed'), findsOneWidget);

    // Tap the Proximity Shield Hero to toggle proximity gate simulation
    await tester.tap(find.byType(ProximityShieldHero));
    await tester.pump(const Duration(milliseconds: 400));

    // Verify Gated / Locked State
    expect(find.text('Proximity Gate Armed'), findsOneWidget);
    expect(find.text('OFF PREMISES • >150m GATED'), findsOneWidget);
    expect(find.text('Wi-Fi Unverified'), findsOneWidget);
    expect(find.text('Biometrics Locked'), findsOneWidget);
    expect(find.text('🔒 Biometrics Locked (Move Near Campus)'), findsOneWidget);

    // Tap again to toggle back
    await tester.tap(find.byType(ProximityShieldHero));
    await tester.pump(const Duration(milliseconds: 400));

    // Verify restored In-Range State
    expect(find.text('Campus Gate Unlocked'), findsOneWidget);
    expect(find.text('ZONE01 HUB • 18m IN RANGE'), findsOneWidget);

    // Test Theme toggle button
    final themeToggleFinder = find.byTooltip('Toggle Theme');
    expect(themeToggleFinder, findsOneWidget);
    await tester.tap(themeToggleFinder);
    await tester.pump(const Duration(milliseconds: 300));
  });
}
