import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mozi_v2/core/constants/route_constants.dart';
import 'package:mozi_v2/core/di/injection.dart';
import 'package:mozi_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/login_cubit.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:mozi_v2/features/auth/presentation/cubit/set_password_cubit.dart';
import 'package:mozi_v2/features/auth/presentation/pages/enter_password_page.dart';
import 'package:mozi_v2/features/auth/presentation/pages/enter_phone_page.dart';
import 'package:mozi_v2/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:mozi_v2/features/auth/presentation/pages/set_password_page.dart';
import 'package:mozi_v2/features/home/presentation/pages/home_page.dart';

/// SplashPage — momentarily shown while AuthBloc.AppStarted resolves
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F9FF),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_car_rounded, size: 72, color: Color(0xFF0057BF)),
            SizedBox(height: 16),
            Text(
              'GoMove',
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0057BF),
                letterSpacing: -1,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(
              color: Color(0xFF0057BF),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

GoRouter buildAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: RouteConstants.splash,
    refreshListenable: _BlocListenable(authBloc),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isOnSplash = state.matchedLocation == RouteConstants.splash;
      final isOnAuth =
          state.matchedLocation.startsWith('/auth');

      if (authState is AuthLoading || authState is AuthInitial) {
        return isOnSplash ? null : RouteConstants.splash;
      }
      if (authState is Authenticated) {
        if (isOnSplash || isOnAuth) return RouteConstants.home;
        return null;
      }
      // Unauthenticated
      if (isOnSplash || isOnAuth) return null;
      return RouteConstants.authPhone;
    },
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteConstants.authPhone,
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<LoginCubit>(),
          child: const EnterPhonePage(),
        ),
      ),
      GoRoute(
        path: RouteConstants.authPassword,
        builder: (context, state) {
          final phone = state.extra as String? ?? '';
          return BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: EnterPasswordPage(phoneNumber: phone),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.authOtp,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return BlocProvider(
            create: (_) => getIt<OtpCubit>(),
            child: OtpVerificationPage(
              phoneNumber: extra['phone'] as String? ?? '',
              purpose: extra['purpose'] as String? ?? 'REGISTRATION',
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.authSetPassword,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return BlocProvider(
            create: (_) => getIt<SetPasswordCubit>(),
            child: SetPasswordPage(
              phoneNumber: extra['phone'] as String? ?? '',
            ),
          );
        },
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}

/// Makes GoRouter re-evaluate redirect whenever AuthBloc emits a new state
class _BlocListenable extends ChangeNotifier {
  _BlocListenable(AuthBloc bloc) {
    bloc.stream.listen((_) => notifyListeners());
  }
}
