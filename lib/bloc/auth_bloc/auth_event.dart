
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthGoogleSignIn extends AuthEvent {}

class AuthSignOut extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}