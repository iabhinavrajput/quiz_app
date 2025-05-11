import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Events
abstract class AuthEvent {}

class UserLoggedIn extends AuthEvent {
  final User user;
  UserLoggedIn(this.user);
}

/// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

/// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    // Register event handler here
    on<UserLoggedIn>((event, emit) {
      emit(Authenticated(event.user));
    });
  }
}
