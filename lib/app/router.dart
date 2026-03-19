import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ridefi_assessment/app/app.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/pages/favorites_page.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/pages/flight_details_page.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/pages/flight_results_page.dart';
import 'package:ridefi_assessment/features/flight_search/presentation/pages/home.dart';
import 'package:ridefi_assessment/features/onboarding/presentation/pages/onboarding.dart';

part 'router.gr.dart';

final appRouterProvider = Provider<AppRouterConfig>(AppRouterConfig.new);

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouterConfig extends RootStackRouter {
  AppRouterConfig(this.ref);
  final Ref ref;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: SplashRoute.page,
      initial: true,
    ),
    AutoRoute(
      page: OnboardingRoute.page,
    ),
    AutoRoute(
      page: HomeRoute.page,
    ),
    AutoRoute(
      page: FlightResultsRoute.page,
    ),
    AutoRoute(
      page: FlightDetailsRoute.page,
    ),
    AutoRoute(
      page: FavoritesRoute.page,
    ),
  ];
}
