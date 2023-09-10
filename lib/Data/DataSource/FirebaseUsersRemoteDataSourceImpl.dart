import 'dart:async';

import 'package:chat/Data/Firebase/ErrorHandeler.dart';
import 'package:chat/Data/Firebase/UsersDataBase.dart';
import 'package:chat/Data/Models/User/UserDTO.dart';
import 'package:chat/Domain/Exception/FirebaseFireStoreDatabaseTimeoutException.dart';
import 'package:chat/Domain/Exception/FirebaseFirestoreDatabaseException.dart';
import 'package:chat/Domain/presenters/FirebaseAuthContract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUsersRemoteDataSourceImpl
    implements FirebaseUsersRemoteDataSource {
  UsersDataBase usersDataBase;
  ErrorHandler errorHandler;
  FirebaseUsersRemoteDataSourceImpl(this.usersDataBase, this.errorHandler);
  @override
  Future<void> addUser(UserDTO user) async {
    try {
      await usersDataBase.addUser(user);
    } on FirebaseException catch (e) {
      var error = errorHandler.handleFirebaseFireStoreError(e.code);
      throw FirebaseFireStoreDatabaseException(error);
    } on TimeoutException catch (e) {
      throw FirebaseFireStoreDatabaseTimeoutException(
          "Thao tác này đã hết thời gian");
    } catch (e) {
      throw FirebaseFireStoreDatabaseException("Lỗi không rõ");
    }
  }

  @override
  Future<bool> userExist(String uid) async {
    try {
      var response = await usersDataBase.userExist(uid);
      return response;
    } on FirebaseException catch (e) {
      var error = errorHandler.handleFirebaseFireStoreError(e.code);
      throw FirebaseFireStoreDatabaseException(error);
    } on TimeoutException catch (e) {
      throw FirebaseFireStoreDatabaseTimeoutException(
          "Thao tác này đã hết thời gian");
    } catch (e) {
      throw FirebaseFireStoreDatabaseException("Lỗi không rõ");
    }
  }
}
