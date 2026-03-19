import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ridefi_assessment/app/injection.config.dart';
import 'package:ridefi_assessment/core/services/api/aviationstack_config.dart';

final GetIt locator = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true,
)
void configureDependencies() => locator.init();

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio {
    final d = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        queryParameters: {
          'access_key': AviationstackConfig.apiKey,
        },
        validateStatus: (status) => true,
        receiveDataWhenStatusError: true,
        baseUrl: AviationstackConfig.baseUrl,
      ),
    );

    d.interceptors.addAll([
      PrettyDioLogger(requestBody: true),
    ]);

    return d;
  }
}
