import 'package:flutter/material.dart';
// 생성한 라이브러리 import
import 'package:ambient_gradient_border/ambient_gradient_border.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(), // 어두운 테마
      home: const GradientBorderDemo(),
    );
  }
}

class GradientBorderDemo extends StatefulWidget {
  const GradientBorderDemo({Key? key}) : super(key: key);

  @override
  _GradientBorderDemoState createState() => _GradientBorderDemoState();
}

class _GradientBorderDemoState extends State<GradientBorderDemo> {
  // 기본 값 설정
  double width = 300;
  double height = 150;
  double strokeWidth = 4.0;
  double radius = 30.0;
  double glowSpread = 12.0;
  double glowWidthMultiplier = 3.5;
  bool showSharpBorder = true;
  Duration animationDuration = const Duration(seconds: 5);

  // 그라데이션 색상
  List<Color> gradientColors = const [
    Colors.deepOrangeAccent,
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.deepPurpleAccent,
    Colors.blueAccent,
    Colors.deepOrangeAccent,
  ];

  // 사전 정의 색상 세트
  List<List<Color>> colorPresets = [
    [
      Colors.deepOrangeAccent,
      Colors.redAccent,
      Colors.pinkAccent,
      Colors.purpleAccent,
      Colors.deepPurpleAccent,
      Colors.blueAccent,
      Colors.deepOrangeAccent,
    ],
    [
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.green,
    ],
    [
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.lightBlue,
      Colors.blue,
    ],
    [
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.indigo,
      Colors.deepPurple,
      Colors.purple,
    ],
  ];

  int selectedColorPreset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambient Gradient Border 데모'),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // 상단부: 미리보기 영역
          Expanded(
            flex: 2,
            child: Center(
              child: AmbientGradientBorder(
                width: width,
                height: height,
                strokeWidth: strokeWidth,
                radius: radius,
                gradientColors: gradientColors,
                glowSpread: glowSpread,
                glowWidthMultiplier: glowWidthMultiplier,
                showSharpBorder: showSharpBorder,
                animationDuration: animationDuration,
                child: Container(
                  child: const Center(
                    child: Text(
                      '옵션 조절 가능',
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
          ),

          // 하단부: 컨트롤 영역
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 색상 프리셋 선택
                    Text('색상 프리셋',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          colorPresets.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColorPreset = index;
                                  gradientColors = colorPresets[index];
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  gradient: LinearGradient(
                                    colors: colorPresets[index],
                                  ),
                                  border: Border.all(
                                    color: selectedColorPreset == index
                                        ? Colors.white
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 외곽선 두께 조절
                    _buildSlider(
                      label: '외곽선 두께',
                      value: strokeWidth,
                      min: 1.0,
                      max: 10.0,
                      divisions: 18,
                      onChanged: (value) {
                        setState(() {
                          strokeWidth = value;
                        });
                      },
                    ),

                    // 모서리 반경 조절
                    _buildSlider(
                      label: '모서리 반경',
                      value: radius,
                      min: 0.0,
                      max: 50.0,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          radius = value;
                        });
                      },
                    ),

                    // 글로우 퍼짐 조절
                    _buildSlider(
                      label: '글로우 퍼짐',
                      value: glowSpread,
                      min: 0.0,
                      max: 20.0,
                      divisions: 20,
                      onChanged: (value) {
                        setState(() {
                          glowSpread = value;
                        });
                      },
                    ),

                    // 글로우 두께 배율 조절
                    _buildSlider(
                      label: '글로우 두께 배율',
                      value: glowWidthMultiplier,
                      min: 1.0,
                      max: 10.0,
                      divisions: 18,
                      onChanged: (value) {
                        setState(() {
                          glowWidthMultiplier = value;
                        });
                      },
                    ),

                    // 애니메이션 속도 조절
                    _buildSlider(
                      label: '애니메이션 속도 (초)',
                      value: animationDuration.inSeconds.toDouble(),
                      min: 1.0,
                      max: 10.0,
                      divisions: 9,
                      onChanged: (value) {
                        setState(() {
                          animationDuration = Duration(seconds: value.toInt());
                        });
                      },
                    ),

                    // 위젯 크기 조절
                    _buildSlider(
                      label: '위젯 너비',
                      value: width,
                      min: 100.0,
                      max: 350.0,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          width = value;
                        });
                      },
                    ),

                    _buildSlider(
                      label: '위젯 높이',
                      value: height,
                      min: 50.0,
                      max: 300.0,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          height = value;
                        });
                      },
                    ),

                    // 선명한 외곽선 표시 여부
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('선명한 외곽선 표시'),
                        Switch(
                          value: showSharpBorder,
                          onChanged: (value) {
                            setState(() {
                              showSharpBorder = value;
                            });
                          },
                          activeColor: Colors.deepPurpleAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 슬라이더 위젯 빌더 메서드
  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value.toStringAsFixed(1)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          activeColor: gradientColors[0],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
