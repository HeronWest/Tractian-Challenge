import 'package:dio/dio.dart';

import '../data/models/asset.dart';

abstract interface class AssetsRepository {
  Future<List<Asset>> getAssets(String companyId);
}

class AssetsRepositoryImpl implements AssetsRepository {

  final Dio _dio;

  AssetsRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<Asset>> getAssets(String companyId) async {
    try {
      final response = await _dio.get('/companies/$companyId/assets');
      return (response.data as List).map((e) => Asset.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}