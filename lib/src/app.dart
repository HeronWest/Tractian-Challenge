import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tractian_challenge/src/features/splash/splash_module.dart';

import 'core/application_bindings.dart';
import 'design/theme.dart';
import 'features/company/company_module.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      bindings: ApplicationBinding(),
        modules: [
          SplashModule(),
          CompanyModule(),
        ],
        builder: (context, routes, getitNavigator) => AsyncStateBuilder(builder: (asyncStateNavigator) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tractian Challenge',
            routes: routes,
            navigatorObservers: [getitNavigator, asyncStateNavigator],
            theme: ThemeData(
              colorScheme: lightColorScheme,
              fontFamily: GoogleFonts.nunito().fontFamily,
            )
        )
        )

    );
  }
}