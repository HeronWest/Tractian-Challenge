import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:tractian_challenge/src/features/company/cubit/assets_cubit.dart';
import 'package:tractian_challenge/src/features/company/pages/company_assets_page.dart';
import 'package:tractian_challenge/src/features/company/cubit/company_cubit.dart';

import 'pages/company_selection_page.dart';

class CompanyModule extends FlutterGetItModule {

  @override
  // TODO: implement bindings
  List<Bind<Object>> get bindings => [
    Bind.singleton((i) => CompanyCubit(repository: i())),
    Bind.singleton((i) => AssetsCubit(repository: i(), locationsRepository: i())),
  ];

  @override
  String get moduleRouteName => '/company';

  @override
  Map<String, WidgetBuilder> get pages => {
    '/selection': (context) => const CompanySelectionPage(),
    '/assets': (context) => const CompanyAssetsPage(),
  };
}