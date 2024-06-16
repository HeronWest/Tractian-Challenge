import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tractian_challenge/src/features/company/cubit/company_cubit.dart';

import 'company_assets_page.dart';

class CompanySelectionPage extends StatefulWidget {
  const CompanySelectionPage({super.key});

  @override
  State<CompanySelectionPage> createState() => _CompanySelectionPageState();
}

class _CompanySelectionPageState extends State<CompanySelectionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.get<CompanyCubit>().getCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Company Selection',
          style: GoogleFonts.nunito(
            fontSize: 24,
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<CompanyCubit, CompanyState>(
          bloc: context.get(),
          builder: (context, state) {
            if (state is CompanyInitial) {
              return const Center(child: Text('Please select a company.'));
            } else if (state is CompanyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CompanySuccess) {
              return FractionallySizedBox(
                heightFactor: 1,
                widthFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: ListView.builder(
                    itemCount: state.companies.length,
                    itemBuilder: (context, index) {
                      return FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: ListTile(
                            minVerticalPadding: 24,
                            title: Text('${state.companies[index].name} Unit', style: GoogleFonts.nunito(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),),
                            leading: Icon(Icons.local_shipping_outlined, color: Theme.of(context).colorScheme.onPrimary,),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            tileColor: Theme.of(context).colorScheme.tertiary,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompanyAssetsPage(
                                  companyId: state.companies[index].id,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            } else if (state is CompanyError) {
              return Center(
                  child: Text('Failed to load companies: ${state.message}'));
            } else {
              return const Center(child: Text('Unknown state.'));
            }
          }),
    );
  }
}
