import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridefi_assessment/app/router.dart';

class RideFiAssessment extends ConsumerStatefulWidget {
  const RideFiAssessment({super.key});

  @override
  ConsumerState<RideFiAssessment> createState() => _RideFiAssessmentState();
}

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Icon(Icons.flight)),
    );
  }
}
  
class _RideFiAssessmentState extends ConsumerState<RideFiAssessment> {
  @override
  Widget build(BuildContext context) {
    final router = ref.read(appRouterProvider);

    return MaterialApp.router(
      title: 'Flight Search App',
      debugShowCheckedModeBanner: false,
      routerConfig: router.config(),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        ref.read(appRouterProvider).replace(const OnboardingRoute());
      });
    });
  }
}
