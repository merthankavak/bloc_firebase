import 'package:bloc_firebase/product/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../product/model/custom_error_model.dart';
import '../../../product/model/user_model.dart';
import '../../../product/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  final AuthRepository authRepository;
  ProfileCubit({required this.profileRepository, required this.authRepository})
      : super(ProfileState.initial());

  Future<void> getProfileData({required String uid}) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));
    try {
      final UserModel userModel = await profileRepository.getProfileData(uid: uid);
      emit(state.copyWith(profileStatus: ProfileStatus.loaded, userModel: userModel));
    } on CustomErrorModel catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.error,
        customErrorModel: e,
      ));
    }
  }

  Future<void> updateProfileData({required String uid, required String name}) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));
    try {
      final UserModel userModel = await profileRepository.updateProfileData(uid: uid, name: name);
      emit(state.copyWith(profileStatus: ProfileStatus.loaded, userModel: userModel));
    } on CustomErrorModel catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.error,
        customErrorModel: e,
      ));
    }
  }

  Future<void> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));
    try {
      await authRepository.changePassword(
          currentPassword: currentPassword, newPassword: newPassword);
      emit(state.copyWith(profileStatus: ProfileStatus.loaded));
    } on CustomErrorModel catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.error,
        customErrorModel: e,
      ));
    }
  }
}
