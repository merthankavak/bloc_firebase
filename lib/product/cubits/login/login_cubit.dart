import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../product/model/custom_error_model.dart';
import '../../../../product/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository
      authRepository; // Signin işlemi yapacağımız için auth repositoryi ekledik. Neden stream subs eklemedik diye sorarsan çünkü stream olan birtek user vardı. User ı dinlememizi gerektiren bir sebep yok. Zaten user dinleme işini auth bloc yaparak auth olup olmadığına karar veriyor.

  LoginCubit({required this.authRepository}) : super(LoginState.initial());

  void toggleObscure() {
    emit(state.copyWith(isObscure: !state.isObscure));
  }

  Future<void> signIn({required String email, required String password}) async {
    // Bu işlemi yapmaya başlıyorsa birkere login statusu initialdan submittinge alman gerek. Çünkü işlem yapılıyor.
    emit(state.copyWith(loginStatus: LoginStatus.submitting));

    try {
      await authRepository.signIn(email: email, password: password); // Login işlemi yapılıyor.
      emit(state.copyWith(
        loginStatus: LoginStatus.success,
      )); // Zaten bu satıra gelirsek işlem hatasız gerçekleşmiş demektir yani stateye success verebiliriz.
    } on CustomErrorModel catch (e) {
      // Custom error yakalıyoruz çünkü authRepository custom error döndürüyor.
      emit(state.copyWith(
        loginStatus: LoginStatus.error,
        customErrorModel: e,
      )); // Error yakalarsa login status stateni errora çekiyoruz ve erroru stateye veriyoruz.
    }
  }
}
