part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStateChangedEvent extends AuthEvent {
  final fb_auth.User? user; // Evente dışardan payload ediyoruz. Yani dışardan değer gönderecez.

  const AuthStateChangedEvent({
    this.user,
  });

  @override
  List<Object?> get props => [user];
}

class SignOutRequestedEvent extends AuthEvent {}
