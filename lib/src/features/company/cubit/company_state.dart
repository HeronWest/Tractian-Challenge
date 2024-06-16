part of 'company_cubit.dart';

sealed class CompanyState {}

final class CompanyInitial extends CompanyState {}

final class CompanyLoading extends CompanyState {}

final class CompanySuccess extends CompanyState {
  final List<Company> companies;

  CompanySuccess({required this.companies});
}

final class CompanyError extends CompanyState {
  final String message;

  CompanyError({required this.message});
}