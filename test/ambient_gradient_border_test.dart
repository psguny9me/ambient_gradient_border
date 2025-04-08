import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ambient_gradient_border/ambient_gradient_border.dart';

void main() {
  testWidgets('AmbientGradientBorder 위젯이 생성되고 자식 위젯을 표시합니다',
      (WidgetTester tester) async {
    // 위젯 생성
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AmbientGradientBorder(
              width: 300,
              height: 300,
              strokeWidth: 2.0,
              radius: 16.0,
              gradientColors: const [Colors.blue, Colors.purple, Colors.blue],
              glowSpread: 3.0,
              glowWidthMultiplier: 1.5,
              child: const SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: Text('테스트 텍스트'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // 위젯이 렌더링되었는지 확인
    expect(find.byType(AmbientGradientBorder), findsOneWidget);

    // 자식 위젯이 렌더링되었는지 확인
    expect(find.text('테스트 텍스트'), findsOneWidget);
  });

  testWidgets('AmbientGradientBorder의 속성이 올바르게 전달됩니다',
      (WidgetTester tester) async {
    // 위젯 생성 (커스텀 속성 지정)
    final List<Color> testColors = [Colors.red, Colors.green, Colors.blue];
    const double testWidth = 320.0;
    const double testHeight = 220.0;
    const double testStrokeWidth = 8.0;
    const double testRadius = 24.0;
    const double testGlowSpread = 5.0;
    const double testGlowWidthMultiplier = 2.0;
    const Duration testDuration = Duration(seconds: 3);
    const bool testShowSharpBorder = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AmbientGradientBorder(
              width: testWidth,
              height: testHeight,
              strokeWidth: testStrokeWidth,
              radius: testRadius,
              gradientColors: testColors,
              glowSpread: testGlowSpread,
              glowWidthMultiplier: testGlowWidthMultiplier,
              animationDuration: testDuration,
              showSharpBorder: testShowSharpBorder,
              child: const SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: Text('속성 테스트'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // 위젯 찾기
    final AmbientGradientBorderFinder = find.byType(AmbientGradientBorder);
    expect(AmbientGradientBorderFinder, findsOneWidget);

    // 위젯 속성 확인
    final AmbientGradientBorder widget =
        tester.widget(AmbientGradientBorderFinder);
    expect(widget.width, equals(testWidth));
    expect(widget.height, equals(testHeight));
    expect(widget.strokeWidth, equals(testStrokeWidth));
    expect(widget.radius, equals(testRadius));
    expect(widget.gradientColors, equals(testColors));
    expect(widget.glowSpread, equals(testGlowSpread));
    expect(widget.glowWidthMultiplier, equals(testGlowWidthMultiplier));
    expect(widget.animationDuration, equals(testDuration));
    expect(widget.showSharpBorder, equals(testShowSharpBorder));
  });
}
