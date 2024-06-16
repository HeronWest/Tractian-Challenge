import 'package:dio/dio.dart';

import '../data/models/location.dart';

abstract interface class LocationsRepository {
  Future<List<Location>> getLocations(String companyId);
}

class LocationsRepositoryImpl implements LocationsRepository {
  final Dio _dio;

  LocationsRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<Location>> getLocations(String companyId) async {
    try {
      final response = await _dio.get('/companies/$companyId/locations');
      return (response.data as List).map((e) => Location.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}