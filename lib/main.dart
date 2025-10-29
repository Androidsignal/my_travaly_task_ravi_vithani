import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_travaly_task/routes.dart';
import 'package:my_travaly_task/theme/app_theme.dart';

import 'bloc/auth_bloc/auth_bloc.dart';
import 'constants/app_strings.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppTheme.buildAppTheme(),
        initialRoute: Routes.signIn,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}