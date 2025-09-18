import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demoflutter/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DApp());

    // Verify that the app title is displayed
    expect(find.text('Marine Invertebrate Classifier'), findsOneWidget);
    
    // Verify that camera and gallery buttons are present
    expect(find.text('Camera'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
    
    // Verify that the main description is present
    expect(find.text('Classify Marine Invertebrates'), findsOneWidget);
  });
  
  testWidgets('Camera and Gallery buttons are interactive', (WidgetTester tester) async {
    await tester.pumpWidget(const DApp());
    
    // Find the camera button
    final cameraButton = find.widgetWithText(ElevatedButton, 'Camera');
    expect(cameraButton, findsOneWidget);
    
    // Find the gallery button
    final galleryButton = find.widgetWithText(ElevatedButton, 'Gallery');
    expect(galleryButton, findsOneWidget);
    
    // Verify buttons are enabled (this would be disabled during loading)
    final cameraButtonWidget = tester.widget<ElevatedButton>(cameraButton);
    final galleryButtonWidget = tester.widget<ElevatedButton>(galleryButton);
    
    // Note: In a real test environment, these might be disabled due to model loading
    // This test verifies the widgets exist and are properly structured
    expect(cameraButtonWidget.onPressed, isNotNull);
    expect(galleryButtonWidget.onPressed, isNotNull);
  });
}