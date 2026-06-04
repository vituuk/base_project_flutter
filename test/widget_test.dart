import 'package:demo_2/app/app.dart';
import 'package:demo_2/app/core/theme/theme_controller.dart';
import 'package:demo_2/app/core/constants/auth/auth_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('App launches on LoginPage and displays phone login fields', (
    WidgetTester tester,
  ) async {
    // Register ThemeController which is required by DemoApp's build method
    Get.put(ThemeController(), permanent: true);

    await tester.pumpWidget(const DemoApp());

    // Wait for route initialization and animations
    await tester.pumpAndSettle();

    // Verify LoginPage renders with the correct heading and verify button text
    expect(find.text(AuthConstants.loginHeading), findsOneWidget);
    expect(find.text(AuthConstants.loginVerifyButton), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });
}
