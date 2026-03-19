// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:ridefi_assessment/app/injection.dart' as _i693;
import 'package:ridefi_assessment/core/services/api/api_client.dart' as _i366;
import 'package:ridefi_assessment/core/services/database_service.dart' as _i649;
import 'package:ridefi_assessment/features/flight_search/data/repositories/flight_repository.dart'
    as _i913;
import 'package:ridefi_assessment/features/flight_search/data/services/favorites_service.dart'
    as _i681;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i649.DatabaseService>(() => _i649.DatabaseServiceImpl());
    gh.lazySingleton<_i681.FavoritesService>(
      () => _i681.FavoritesService(gh<_i649.DatabaseService>()),
    );
    gh.lazySingleton<_i366.ApiClient>(() => _i366.ApiClient(gh<_i361.Dio>()));
    gh.lazySingleton<_i913.FlightRepository>(
      () => _i913.FlightRepositoryImpl(gh<_i366.ApiClient>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i693.RegisterModule {}
