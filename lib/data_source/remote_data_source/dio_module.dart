import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../config/app_constants.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio => Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
    ),
  );
}
