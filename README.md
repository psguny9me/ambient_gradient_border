# ambient_gradient_border

`ambient_gradient_border` 패키지는 Flutter 앱에서 사용할 수 있는 아름다운 애니메이션 그라데이션 테두리 효과를 제공하는 라이브러리입니다. 어두운 배경에서 최적의 효과를 나타내며, 위젯에 현대적인 글로우 효과를 추가할 수 있습니다.

## 특징

- 부드러운 그라데이션 테두리 애니메이션
- 사용자 정의 가능한 글로우 효과
- 커스텀 모서리 반경 지원
- 간단한 API로 모든 Flutter 위젯과 함께 사용 가능
- 다양한 조절 가능한 파라미터로 시각적 효과 커스터마이징

## 설치

pubspec.yaml에 패키지 추가:

```yaml
dependencies:
  ambient_gradient_border: ^0.1.0
```

## 기본 사용법

```dart
import 'package:flutter/material.dart';
import 'package:ambient_gradient_border/ambient_gradient_border.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 어두운 배경 권장
      body: Center(
        child: AmbientGradientBorder(
          width: 300,
          height: 150,
          strokeWidth: 4.0,
          radius: 30.0,
          gradientColors: const [
            Colors.deepOrangeAccent,
            Colors.redAccent,
            Colors.purpleAccent,
            Colors.blueAccent,
            Colors.deepOrangeAccent,
          ],
          glowSpread: 12.0,
          glowWidthMultiplier: 3.5,
          showSharpBorder: true,
          child: Container(
            child: Center(
              child: Text(
                'Ambient Gradient',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## 속성

| 속성 | 설명 | 기본값 | 필수 여부 |
|---|---|---|---|
| `width` | 위젯의 전체 너비 | - | 필수 |
| `height` | 위젯의 전체 높이 | - | 필수 |
| `strokeWidth` | 테두리 선의 두께 (픽셀) | - | 필수 |
| `radius` | 테두리 모서리의 반경 | - | 필수 |
| `gradientColors` | 그라데이션에 사용할 색상 목록 (최소 2개) | - | 필수 |
| `glowSpread` | 글로우 효과의 퍼짐 정도 (블러 시그마 값) | - | 필수 |
| `glowWidthMultiplier` | 글로우 효과의 두께 배율 | - | 필수 |
| `child` | 테두리 내부에 표시할 위젯 | - | 필수 |
| `animationDuration` | 그라데이션 애니메이션 한 사이클의 지속 시간 | Duration(seconds: 5) | 선택적 |
| `showSharpBorder` | 선명한 외곽선 표시 여부 | false | 선택적 |

## 고급 사용법

AmbientGradientBorder는 다양한 매개변수를 조절하여 원하는 효과를 만들 수 있습니다:

```dart
AmbientGradientBorder(
  width: 320,
  height: 220,
  strokeWidth: 8.0,
  radius: 24.0,
  gradientColors: [
    Colors.red,
    Colors.green,
    Colors.blue,
  ],
  glowSpread: 5.0,
  glowWidthMultiplier: 2.0,
  animationDuration: Duration(seconds: 3),
  showSharpBorder: false,
  child: YourWidget(),
)
```

## 사용 팁

1. 최상의 글로우 효과를 위해 어두운 배경에서 사용하세요.
2. 글로우 효과의 퍼짐 정도는 `glowSpread` 값으로 조절할 수 있습니다.
3. 테두리의 두께는 `strokeWidth`로, 글로우의 두께는 `glowWidthMultiplier`로 조절할 수 있습니다.
4. 외곽선이 필요 없고 글로우 효과만 원하는 경우 `showSharpBorder`를 false로 설정하세요.
5. 그라데이션 색상 목록의 첫 번째와 마지막 색상을 동일하게 설정하면 부드러운 순환 효과를 얻을 수 있습니다.

## 예제 앱

패키지에 포함된 예제 앱에서 다양한 매개변수를 조절하며 효과를 직접 확인할 수 있습니다:

```bash
cd example
flutter run
```
