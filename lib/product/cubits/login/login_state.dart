part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  final LoginStatus loginStatus;
  final CustomErrorModel customErrorModel;
  final bool isObscure;

  const LoginState({
    required this.loginStatus,
    required this.customErrorModel,
    required this.isObscure,
  });

  factory LoginState.initial() {
    return const LoginState(
      loginStatus: LoginStatus.initial,
      customErrorModel: CustomErrorModel(),
      isObscure: true,
    );
  }

  @override
  List<Object> get props => [loginStatus, customErrorModel, isObscure];

  LoginState copyWith({
    LoginStatus? loginStatus,
    CustomErrorModel? customErrorModel,
    bool? isObscure,
  }) {
    return LoginState(
        loginStatus: loginStatus ?? this.loginStatus,
        customErrorModel: customErrorModel ?? this.customErrorModel,
        isObscure: isObscure ?? this.isObscure);
  }

  @override
  String toString() => 'LoginState(loginStatus: $loginStatus, customErrorModel: $customErrorModel)';
}
