import 'package:dio/dio.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:tractian_challenge/src/repositories/companies_repository.dart';
import 'package:tractian_challenge/src/repositories/assets_repository.dart';
import 'package:tractian_challenge/src/repositories/locations_repository.dart';


import 'interceptor/api_req_intercept.dart';

class ApplicationBinding extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
    Bind.lazySingleton<Dio>((i)=>Dio()..interceptors.add(ApiReqIntercept())),
    Bind.lazySingleton<CompanyRepository>((i) => CompanyRepositoryImpl(dio: i())),
    Bind.lazySingleton<AssetsRepository>((i) => AssetsRepositoryImpl(dio: i())),
    Bind.lazySingleton<LocationsRepository>((i) => LocationsRepositoryImpl(dio: i()))
  ];
}