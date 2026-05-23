import 'package:flutter_test/flutter_test.dart';
import 'package:movies/main.dart';
import 'package:movies/presentation/feature/onboarding/splash_screen.dart';

void main() {
  testWidgets('app starts on splash screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
