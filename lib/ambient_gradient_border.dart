import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class AmbientGradientBorder extends StatefulWidget {
  final double width;
  final double height;
  final double strokeWidth; // 최종 외곽선 두께 (및 글로우 위치 기준)
  final double radius;
  final List<Color> gradientColors;
  final double glowSpread; // 글로우 퍼짐 정도 (sigma)
  final double glowWidthMultiplier; // 글로우 두께 배율 (다시 사용)
  final Widget child;
  final Duration animationDuration;
  final bool showSharpBorder; // 선명한 외곽선 표시 여부

  const AmbientGradientBorder({
    Key? key,
    required this.width,
    required this.height,
    required this.strokeWidth,
    required this.radius,
    required this.gradientColors,
    required this.glowSpread,
    required this.glowWidthMultiplier, // *** 다시 추가 ***
    required this.child,
    this.animationDuration = const Duration(seconds: 5),
    this.showSharpBorder = false, // <<< 기본값을 false로 변경 (외곽선 없어도 효과 잘 보임)
  })  : assert(strokeWidth > 0),
        assert(radius >= 0),
        assert(gradientColors.length >= 2),
        assert(glowSpread >= 0),
        assert(glowWidthMultiplier > 0), // *** 다시 추가 ***
        super(key: key);

  @override
  _AmbientGradientBorderState createState() => _AmbientGradientBorderState();
}

class _AmbientGradientBorderState extends State<AmbientGradientBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 내부 컨텐츠 영역 계산 (외곽선 두께만큼 안쪽)
    final innerRadiusValue = math.max(0.0, widget.radius - widget.strokeWidth);
    final innerBorderRadius = BorderRadius.circular(innerRadiusValue);
    final innerWidth = math.max(0.0, widget.width - widget.strokeWidth * 2);
    final innerHeight = math.max(0.0, widget.height - widget.strokeWidth * 2);

    // 내부 컨텐츠 컨테이너의 배경색 결정 (중요: 글로우 안쪽 가리기용)
    // 기본적으로 Scaffold 배경색을 사용하거나, 필요시 명시적으로 지정
    final Color internalBackgroundColor =
        Theme.of(context).scaffoldBackgroundColor;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // --- 레이어 1: 앰비언트 글로우 (바깥쪽으로 확장된 위치에 그림) ---
              CustomPaint(
                size: Size(widget.width, widget.height),
                painter: _AmbientOuterEffectPainter(
                  // Painter 이름 변경 (의미 명확화)
                  strokeWidth: widget.strokeWidth,
                  radius: widget.radius,
                  gradientColors: widget.gradientColors,
                  animationValue: _controller.value,
                  glowSpread: widget.glowSpread,
                  glowWidthMultiplier: widget.glowWidthMultiplier, // *** 전달 ***
                ),
              ),

              // --- 레이어 2: 내부 컨텐츠 영역 (안쪽 글로우를 가림) ---
              Container(
                width: innerWidth,
                height: innerHeight,
                decoration: BoxDecoration(
                  // *** 중요: 불투명한 배경색으로 안쪽 글로우를 가려야 함 ***
                  color: internalBackgroundColor,
                  borderRadius: innerBorderRadius,
                ),
                // ClipRRect는 자식 위젯이 내부 경계를 넘지 않도록 함
                child: ClipRRect(
                  borderRadius: innerBorderRadius,
                  child: widget.child,
                ),
              ),

              // --- 레이어 3: (선택 사항) 선명한 외곽선 ---
              if (widget.showSharpBorder)
                CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: _AnimatedGradientStrokePainter(
                    strokeWidth: widget.strokeWidth,
                    radius: widget.radius,
                    gradientColors: widget.gradientColors,
                    animationValue: _controller.value,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// 바깥쪽 글로우 효과를 내기 위해 확장된 위치에 블러를 그리는 Painter
class _AmbientOuterEffectPainter extends CustomPainter {
  final double strokeWidth; // 기준 외곽선 두께
  final double radius;
  final List<Color> gradientColors;
  final double animationValue;
  final double glowSpread; // 블러 sigma 값
  final double glowWidthMultiplier; // 글로우 두께 배율

  _AmbientOuterEffectPainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradientColors,
    required this.animationValue,
    required this.glowSpread,
    required this.glowWidthMultiplier, // *** 받음 ***
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 글로우 효과를 위한 Paint 설정
    final double glowPaintStrokeWidth =
        strokeWidth * glowWidthMultiplier; // 글로우 두께
    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = glowPaintStrokeWidth // 두꺼운 스트로크
      // *** BlurStyle.normal 사용 ***
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowSpread);

    // *** 글로우와 라인 사이의 간격 최소화를 위한 RRect 계산 수정 ***
    // 원래 계산 방식보다 글로우를 라인에 더 가깝게 배치
    final Rect rect = Rect.fromLTWH(
        strokeWidth / 2, // 왼쪽 경계
        strokeWidth / 2, // 상단 경계
        size.width - strokeWidth, // 너비
        size.height - strokeWidth // 높이
        );

    // Radius도 실제 라인 위치에 맞게 조정
    final Radius borderRadius =
        Radius.circular(math.max(0, radius - strokeWidth / 2));
    final RRect glowRRect = RRect.fromRectAndRadius(rect, borderRadius);

    // 애니메이션 그라데이션 생성
    final SweepGradient sweepGradient = SweepGradient(
      center: Alignment.center,
      colors: gradientColors,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      transform: GradientRotation(animationValue * 2 * math.pi),
      tileMode: TileMode.repeated,
    );

    // 그라데이션 Shader 적용 (전체 영역 기준)
    glowPaint.shader = sweepGradient
        .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // 계산된 RRect에 블러 처리된 글로우 그리기
    canvas.drawRRect(glowRRect, glowPaint);
  }

  @override
  bool shouldRepaint(covariant _AmbientOuterEffectPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        !listEquals(oldDelegate.gradientColors, gradientColors) ||
        oldDelegate.glowSpread != glowSpread ||
        oldDelegate.glowWidthMultiplier != glowWidthMultiplier; // *** 비교 추가 ***
  }

  // listEquals 함수 (간단 버전)
  bool listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// (선택 사항) 선명한 애니메이션 그라데이션 외곽선만 그리는 Painter
class _AnimatedGradientStrokePainter extends CustomPainter {
  // ... (이전과 동일, 필요시 listEquals 추가)
  final double strokeWidth;
  final double radius;
  final List<Color> gradientColors;
  final double animationValue;

  _AnimatedGradientStrokePainter({
    required this.strokeWidth,
    required this.radius,
    required this.gradientColors,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final RRect outerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth,
          size.height - strokeWidth),
      Radius.circular(math.max(0, radius - strokeWidth / 2)),
    );
    final SweepGradient sweepGradient = SweepGradient(
      center: Alignment.center,
      colors: gradientColors,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      transform: GradientRotation(animationValue * 2 * math.pi),
      tileMode: TileMode.repeated,
    );
    borderPaint.shader = sweepGradient
        .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRRect(outerRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _AnimatedGradientStrokePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        !listEquals(oldDelegate.gradientColors, gradientColors); // 리스트 비교
  }

  bool listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
