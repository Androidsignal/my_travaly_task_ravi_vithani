import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_travaly_task/bloc/auth_bloc/auth_bloc.dart';
import 'package:my_travaly_task/pages/home_page.dart';
import 'package:my_travaly_task/pages/search_page.dart';
import 'package:my_travaly_task/pages/sign_in_page.dart';

import 'models/search_model.dart';

class Routes {
  static const String signIn = '/';
  static const String home = '/home';
  static const String search = '/search';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case Routes.home:
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(value: BlocProvider.of<AuthBloc>(context), child: const HomePage()),
        );
      case Routes.search:
        final args = settings.arguments;
        return MaterialPageRoute(builder: (_) => SearchPage(searchModel: args is SearchModel ? args : null));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text('No route defined for "${settings.name}"'))),
        );
    }
  }
}
