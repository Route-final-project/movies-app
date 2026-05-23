import 'package:flutter_test/flutter_test.dart';
import 'package:movies/main.dart';
import 'package:movies/presentation/feature/onboarding/onboarding_screen.dart';

void main() {
  testWidgets('app starts on onboarding for first time users', (tester) async {
    await tester.pumpWidget(const MoviesApp(hasSeenOnboarding: false));

    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
