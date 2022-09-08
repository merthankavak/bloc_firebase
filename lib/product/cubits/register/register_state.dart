part of 'register_cubit.dart';

enum RegisterStatus { initial, submitting, success, error }

class RegisterState extends Equatable {
  final RegisterStatus registerStatus;
  final CustomErrorModel customErrorModel;
  final bool isObscure;

  const RegisterState({
    required this.registerStatus,
    required this.customErrorModel,
    required this.isObscure,
  });

  factory RegisterState.initial() {
    return const RegisterState(
      registerStatus: RegisterStatus.initial,
      customErrorModel: CustomErrorModel(),
      isObscure: true,
    );
  }

  @override
  List<Object> get props => [registerStatus, customErrorModel, isObscure];

  RegisterState copyWith({
    RegisterStatus? registerStatus,
    CustomErrorModel? customErrorModel,
    bool? isObscure,
  }) {
    return RegisterState(
        registerStatus: registerStatus ?? this.registerStatus,
        customErrorModel: customErrorModel ?? this.customErrorModel,
        isObscure: isObscure ?? this.isObscure);
  }

  @override
  String toString() =>
      'RegisterState(registerStatus: $registerStatus, customErrorModel: $customErrorModel, isObscure: $isObscure)';
}
