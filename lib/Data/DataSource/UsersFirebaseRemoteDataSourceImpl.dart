import 'dart:async';

import 'package:chat/Data/Firebase/ErrorHandeler.dart';
import 'package:chat/Data/Firebase/RoomUsersDataBase.dart';
import 'package:chat/Data/Models/User/UserDTO.dart';
import 'package:chat/Domain/Exception/FirebaseFireStoreDatabaseTimeoutException.dart';
import 'package:chat/Domain/Exception/FirebaseFirestoreDatabaseException.dart';
import 'package:chat/Domain/Models/User/Users.dart';
import 'package:chat/Domain/presenters/UsersRepositoryContract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersFirebaseRemoteDataSourceImpl
    implements UsersFirebaseRemoteDataSource {
  RoomUsersDatabase database;
  ErrorHandler errorHandler;

  UsersFirebaseRemoteDataSourceImpl(this.database, this.errorHandler);

  @override
  Future<String> addUser(String roomId, UserDTO user) async {
    try {
      await database.addRoomMember(roomId, user);
      return "Người dùng đã được thêm thành công";
    } on FirebaseException catch (e) {
      var error = errorHandler.handleFirebaseFireStoreError(e.code);
      throw FirebaseFireStoreDatabaseException(error);
    } on TimeoutException catch (e) {
      throw FirebaseFireStoreDatabaseTimeoutException(
          "Thao tác này đã hết thời gian");
    } catch (e) {
      throw FirebaseFireStoreDatabaseException("Lỗi không xác định");
    }
  }

  @override
  Future<String> removeUser(String roomId, String userId) async {
    try {
      await database.removeRoomMember(roomId, userId);
      return "Người dùng đã được xoá thành công";
    } on FirebaseException catch (e) {
      var error = errorHandler.handleFirebaseFireStoreError(e.code);
      throw FirebaseFireStoreDatabaseException(error);
    } on TimeoutException catch (e) {
      throw FirebaseFireStoreDatabaseTimeoutException(
          "Thao tác này đã hết thời gian");
    } catch (e) {
      throw FirebaseFireStoreDatabaseException("Lỗi không xác định");
    }
  }

  @override
  Future<List<Users>> getUsersList(String roomId) async {
    var response = await database.getRoomUsersList(roomId);
    return response.map((e) => e.toDomain()).toList();
  }
}
