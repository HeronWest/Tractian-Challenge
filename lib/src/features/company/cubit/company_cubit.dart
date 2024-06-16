import 'package:bloc/bloc.dart';

import '../../../data/models/company.dart';
import '../../../repositories/companies_repository.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  final CompanyRepository repository;

  CompanyCubit({required this.repository}) : super(CompanyInitial());

  void getCompanies() async {
    emit(CompanyLoading());
    try {
      final companies = await repository.getCompanies();
      emit(CompanySuccess(companies: companies));
    } catch (e) {
      emit(CompanyError(message: e.toString()));
    }
  }
}
