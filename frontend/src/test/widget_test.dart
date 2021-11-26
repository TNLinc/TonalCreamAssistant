import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:TonalCreamAssistant/local_main.dart';

void main() {
  testWidgets('Initialization start page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(const Key('MaterialAppWidget')), findsOneWidget);

    await tester.pump();

    expect(find.byKey(const Key('MainHeader')), findsOneWidget);

    final CameraButton = find.byIcon(Icons.camera);
    final ImageButton = find.byIcon(Icons.add_photo_alternate);

    expect(CameraButton, findsOneWidget);
    expect(ImageButton, findsOneWidget);

  });

  testWidgets('Check StepList', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byKey(const Key('StepList')), findsOneWidget);

    expect(find.text("Take a photo"), findsOneWidget);
    expect(find.text("Wait for result"), findsOneWidget);
    expect(find.text("Check recommendations"), findsOneWidget);
    expect(find.text("Share results"), findsOneWidget);
  });

  testWidgets('Check Buttons', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    final CameraButton = find.byIcon(Icons.camera);
    final ImageButton = find.byIcon(Icons.add_photo_alternate);

    expect(CameraButton, findsOneWidget);
    expect(ImageButton, findsOneWidget);
  });
}

