import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final String _logo = 'assets/images/tractian.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Image.asset('assets/images/tractian.svg-logo.png', width: 400,),
              SvgPicture.asset(
                _logo,
                width: 400,
              ),
              const SizedBox(
                height: 24.0,
              ),
              Text(
                'Challenge',
                style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onPrimary,
                    height: 0.5),
              ),
              const SizedBox(
                height: 64.0,
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 2),
                duration: const Duration(seconds: 4),
                onEnd: () => Navigator.pushReplacementNamed(
                    context, '/company/selection'),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                      value: value,
                      color: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.secondary);
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              const Text('wait while we prepare everything for you!',
                  style: TextStyle(color: Colors.white)),
              const Spacer(),
              Text(
                'All Rigths Reserved Tractian Challenge © 2024',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w400,
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
