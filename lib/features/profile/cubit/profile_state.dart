part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final ProfileStatus profileStatus;
  final UserModel userModel;
  final CustomErrorModel customErrorModel;

  const ProfileState({
    required this.profileStatus,
    required this.userModel,
    required this.customErrorModel,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profileStatus: ProfileStatus.initial,
      userModel: UserModel.initialUser(),
      customErrorModel: const CustomErrorModel(),
    );
  }

  @override
  List<Object> get props => [profileStatus, userModel, customErrorModel];

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserModel? userModel,
    CustomErrorModel? customErrorModel,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      userModel: userModel ?? this.userModel,
      customErrorModel: customErrorModel ?? this.customErrorModel,
    );
  }

  @override
  String toString() =>
      'ProfileState(profileStatus: $profileStatus, userModel: $userModel, customErrorModel: $customErrorModel)';
}
