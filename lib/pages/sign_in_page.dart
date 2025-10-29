import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../constants/app_strings.dart';
import '../routes.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
          }

          if (state is AuthSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(Routes.home);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Spacer(),
                  CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/logov1.png')),
                  const SizedBox(height: 24),
                  Text(AppStrings.welcome, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.findEpicInline,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 50),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator();
                      }
                      return OutlinedButton.icon(
                        icon: Image.asset(
                          'assets/google.png',
                          width: 20,
                          height: 20,
                          errorBuilder: (_, __, ___) {
                            return const Icon(Icons.login);
                          },
                        ),
                        label: const Text(AppStrings.signInWithGoogle),
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthGoogleSignIn());
                        },
                        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
