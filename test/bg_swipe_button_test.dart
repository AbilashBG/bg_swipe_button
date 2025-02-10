import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bg_swipe_button/bg_swipe_button.dart'; // Import the BGSwipeButton package

void main() {
  testWidgets('BGSwipeButton swipe functionality test',
      (WidgetTester tester) async {
    /// Build the BGSwipeButton widget
    bool isCompleted = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BGSwipeButton(
            onCompleted: () {
              isCompleted = true;
            },
            text: 'Swipe to complete',
            completedText: 'Completed!',
            beforeSwipeTextColor: Colors.white,
            afterSwipeTextColor: Colors.black,
            beforeSwipeIcon: Icon(Icons.arrow_forward_ios, color: Colors.white),
            afterSwipeIcon: Icon(Icons.check, color: Colors.white),
            backgroundColor: Colors.blue,
            completeColor: Colors.green,
            buttonRadius: 30.0,
            gradientColors: [Colors.purple, Colors.pink],
          ),
        ),
      ),
    );

    /// Verify the initial state
    expect(find.text('Swipe to complete'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    expect(isCompleted, isFalse);

    /// Simulate horizontal drag to swipe the button
    final gesture = await tester.startGesture(Offset(10.0, 20.0));
    await tester.pumpAndSettle();

    /// Drag to the right (simulate swipe action)
    await gesture.moveBy(Offset(200.0, 0.0));
    await tester.pumpAndSettle();

    /// Verify the button moved
    expect(find.text('Swipe to complete'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

    /// Complete the swipe (simulate swipe completion)
    await gesture.moveBy(Offset(300.0, 0.0));
    await tester.pumpAndSettle();

    /// Verify the swipe completion
    expect(find.text('Completed!'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(isCompleted, isTrue);
  });

  testWidgets('BGSwipeButton reset swipe after dragging not enough',
      (WidgetTester tester) async {
    /// Build the BGSwipeButton widget
    bool isCompleted = false;
    double swipePosition = 0.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BGSwipeButton(
            onCompleted: () {
              isCompleted = true;
            },
            text: 'Swipe to complete',
            completedText: 'Completed!',
            beforeSwipeTextColor: Colors.white,
            afterSwipeTextColor: Colors.black,
            beforeSwipeIcon: Icon(Icons.arrow_forward_ios, color: Colors.white),
            afterSwipeIcon: Icon(Icons.check, color: Colors.white),
            backgroundColor: Colors.blue,
            completeColor: Colors.green,
            buttonRadius: 30.0,
            gradientColors: [Colors.purple, Colors.pink],
          ),
        ),
      ),
    );

    /// Simulate horizontal drag to swipe the button, but not far enough to complete it
    final gesture = await tester.startGesture(Offset(10.0, 20.0));
    await tester.pumpAndSettle();

    /// Drag partially to the right
    await gesture.moveBy(Offset(100.0, 0.0));
    await tester.pumpAndSettle();

    /// Verify the button has not yet completed swipe
    expect(find.text('Swipe to complete'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    expect(isCompleted, isFalse);

    /// Simulate drag end without completing the swipe
    await gesture.moveBy(Offset(0.0, 0.0));
    await tester.pumpAndSettle();

    /// Verify the button is reset
    expect(find.text('Swipe to complete'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    expect(isCompleted, isFalse);
  });
}
