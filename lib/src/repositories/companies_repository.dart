import 'package:dio/dio.dart';
import 'package:tractian_challenge/src/data/models/company.dart';

abstract interface class CompanyRepository {
  Future<List<Company>> getCompanies();
}

class CompanyRepositoryImpl implements CompanyRepository {

  final Dio _dio;

  CompanyRepositoryImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<Company>> getCompanies() async {
    try {
      final response = await _dio.get('/companies');
      return (response.data as List).map((e) => Company.fromMap(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}