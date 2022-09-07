import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository; // Auth servisini kullanacaz.
  late final StreamSubscription authSubscription; // Auth servisini dinlememiz lazım.

  AuthBloc({
    required this.authRepository,
  }) : super(AuthState.unknown()) {
    authSubscription = authRepository.user.listen((fb_auth.User? user) {
      add(AuthStateChangedEvent(
          user:
              user)); // Userdaki değişiklikleri auth state changed eventine yollayarak payload ediyoruz.
    }); // Auth subscriptionun içini init ederken doldurduk ve auth repositorynin içindeki stream olan user değeriyle dinliyoruz.

    on<AuthStateChangedEvent>((event, emit) {
      if (event.user != null) {
        // User null değilse geriye bir user objesi hatasız dönüyor demektir. Böylece auth olmuş diyebiliriz ve user objesini stateye verebiliriz.
        emit(state.copyWith(
          authStatus: AuthStatus.authenticated,
          user: event.user,
        ));
      } else {
        // Else ise zaten user objesi null döndüğünden dolayı auth olmamıştır deriz ve auth statusu unauthenticated işaretleyip stateye haber veririz.
        emit(state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          user: null,
        ));
      }
    });

    on<SignOutRequestedEvent>((event, emit) async {
      await authRepository.signOut();
    });
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}
