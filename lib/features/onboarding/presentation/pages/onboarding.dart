// ignore_for_file: parameter_assignments

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ridefi_assessment/app/router.dart';
import 'package:ridefi_assessment/core/gen_assets/assets.gen.dart';
import 'package:ridefi_assessment/core/theme/app_typography.dart';
import 'package:ridefi_assessment/core/widget/app_button.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  double _pageOffset = 0;
  int _currentPage = 0;

  final List<MapEntry<Color, Color>> _backgroundColors = [
    const MapEntry(Color(0xFF3AA6F9), Color(0xFF6FB8F5)),
    const MapEntry(Color(0xFF7C5CE0), Color(0xFFA88BEB)),
    const MapEntry(Color(0xFFFF7A59), Color(0xFFFFA585)),
  ];

  final List<String> _titles = [
    'Search Flights Instantly',
    'Find The Best Deals',
    'Travel With Ease',
  ];

  final List<String> _descriptions = [
    'Find the best flight deals in seconds',
    'Compare prices from hundreds of airlines',
    'Book your next adventure in a few taps',
  ];

  @override
  Widget build(BuildContext context) {
    final startColor =
        _getInterpolatedColor(_pageOffset, true) ?? _backgroundColors.first.key;
    final endColor =
        _getInterpolatedColor(_pageOffset, false) ??
        _backgroundColors.first.value;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startColor, endColor],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final distance = (index - _pageOffset).abs();
                    final scale = (1 - distance * 0.2).clamp(0.8, 1.0);
                    final opacity = (1 - distance).clamp(0.0, 1.0);
                    final rotation =
                        distance * 0.1 * (index > _pageOffset ? 1 : -1);
                    final translationY = distance * 100;

                    return Opacity(
                      opacity: opacity,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(0.0, translationY)
                          ..scale(scale, scale)
                          ..rotateZ(rotation),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  image: DecorationImage(
                                    image: index == 0
                                        ? Assets.images.onboard1.provider()
                                        : index == 1
                                        ? Assets.images.onboard2.provider()
                                        : Assets.images.onboard3.provider(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const Gap(30),
                              Transform.translate(
                                offset: Offset(0, distance * 50),
                                child: Text(
                                  _titles[index],
                                  style: AppTypography.bold20.copyWith(
                                    color: Colors.white,
                                    fontSize: 32,
                                    letterSpacing: -0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Gap(15),
                              Transform.translate(
                                offset: Offset(0, distance * 70),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    _descriptions[index],
                                    style: AppTypography.body1.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const Gap(40),

              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 30,
                  top: 10,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      if (_currentPage < 2) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutQuart,
                        );
                      } else {
                        context.router.replace(const HomeRoute());
                      }
                    },
                    text: _currentPage == 2 ? 'Get Started' : 'Next',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
        _currentPage = _pageOffset.round();
      });
    });
  }

  Color? _getInterpolatedColor(double offset, bool isStart) {
    if (offset < 0) offset = 0;
    if (offset > _backgroundColors.length - 1) {
      offset = (_backgroundColors.length - 1).toDouble();
    }

    final lowerIndex = offset.floor();
    final upperIndex = offset.ceil();
    final t = offset - lowerIndex;

    final lowerColor = isStart
        ? _backgroundColors[lowerIndex].key
        : _backgroundColors[lowerIndex].value;
    final upperColor = isStart
        ? _backgroundColors[upperIndex].key
        : _backgroundColors[upperIndex].value;

    return Color.lerp(lowerColor, upperColor, t);
  }
}
