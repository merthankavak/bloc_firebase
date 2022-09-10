import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/db_constants.dart';
import '../model/custom_error_model.dart';
import '../model/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore firebaseFirestore;

  ProfileRepository({
    required this.firebaseFirestore,
  });

  Future<UserModel> getProfileData({required String uid}) async {
    try {
      final DocumentSnapshot userDoc =
          await usersRef.doc(uid).get(); // Databaseden uuid ye göre verileri çek

      if (userDoc.exists) {
        final currentUser = UserModel.fromDoc(userDoc);
        return currentUser;
      }

      throw 'User not found';
    } on FirebaseException catch (e) {
      throw CustomErrorModel(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomErrorModel(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<UserModel> updateProfileData({
    required String uid,
    required String name,
  }) async {
    try {
      await usersRef.doc(uid).update({
        'name': name,
      });

      final DocumentSnapshot userDoc = await usersRef.doc(uid).get();

      final currentUser = UserModel.fromDoc(userDoc);

      return currentUser;
    } on FirebaseException catch (e) {
      throw CustomErrorModel(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomErrorModel(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
