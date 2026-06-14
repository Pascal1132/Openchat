import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:openchat/presentation/providers/core_providers.dart';
import 'package:openchat/presentation/screens/onboarding_screen.dart';

class FakeApiKeyNotifier extends ApiKeyNotifier {
  @override
  Future<String?> build() async => null;

  @override
  Future<void> setApiKey(String apiKey) async {}

  @override
  Future<void> deleteApiKey() async {}

  @override
  Future<bool> validate(String apiKey) async => true;
}

void main() {
  testWidgets('OpenChat onboarding screen builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiKeyProvider.overrideWith(FakeApiKeyNotifier.new),
        ],
        child: const MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    expect(find.text('Welcome to OpenChat'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
