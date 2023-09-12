import 'dart:async';
import 'dart:io';
import 'package:chat/Data/Firebase/ErrorHandeler.dart';
import 'package:chat/Data/Firebase/FirebaseAuth.dart';
import 'package:chat/Data/Firebase/UsersDataBase.dart';
import 'package:chat/Data/Models/User/UserDTO.dart';
import 'package:chat/Domain/Exception/FirebaseAuthException.dart';
import 'package:chat/Domain/Exception/FirebaseAuthTimeoutException.dart';
import 'package:chat/Domain/presenters/FirebaseAuthContract.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRemoteDataSourceImpl implements FirebaseAuthRemoteDataSource {
  FirebaseAuthConfig firebaseAuthConfig;
  ErrorHandler errorHandler;

  FirebaseAuthRemoteDataSourceImpl(this.firebaseAuthConfig, this.errorHandler);

  @override
  Future<User> createUser(UserDTO user) async {
    try {
      var response = await firebaseAuthConfig
          .createAccount(user)
          .timeout(const Duration(seconds: 15));
      return response;
    } on FirebaseAuthException catch (e) {
      var error = errorHandler.handleRegisterError(e.code);
      throw FirebaseAuthRemoteDataSourceException(error);
    } on TimeoutException catch (e) {
      throw FirebaseAuthTimeoutException("Thao tác này đã hết thời gian");
    } on IOException catch (e) {
      throw FirebaseAuthRemoteDataSourceException("Kiểm tra internet");
    } catch (e) {
      throw FirebaseAuthRemoteDataSourceException(e.toString());
    }
  }

  @override
  Future<User> loginUser(String email, String password) async {
    try {
      var response = await firebaseAuthConfig
          .loginAccount(email, password)
          .timeout(const Duration(seconds: 15));
      return response;
    } on FirebaseAuthException catch (e) {
      var error = errorHandler.handleLoginError(e.code);
      throw FirebaseAuthRemoteDataSourceException(error);
    } on TimeoutException catch (e) {
      throw FirebaseAuthTimeoutException("Thao tác này đã hết thời gian");
    } on IOException catch (e) {
      throw FirebaseAuthRemoteDataSourceException(
          "Kiểm tra kết nối Internet của bạn");
    } catch (e) {
      throw FirebaseAuthRemoteDataSourceException(e.toString());
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      var response = await firebaseAuthConfig.signInWithGoogle();
      return response;
    } on FirebaseAuthException catch (e) {
      var error = errorHandler.handleLoginError(e.code);
      throw FirebaseAuthRemoteDataSourceException(error);
    } on TimeoutException catch (e) {
      throw FirebaseAuthTimeoutException("Thao tác này đã hết thời gian");
    } on IOException catch (e) {
      throw FirebaseAuthRemoteDataSourceException(
          "Kiểm tra kết nối Internet của bạn");
    } catch (e) {
      throw FirebaseAuthRemoteDataSourceException(e.toString());
    }
  }

  @override
  Future<String> signOut() async {
    try {
      await firebaseAuthConfig.signOut();
      return "Đăng xuất thành công";
    } on FirebaseAuthException catch (e) {
      var error = errorHandler.handleLoginError(e.code);
      throw FirebaseAuthRemoteDataSourceException(error);
    } on TimeoutException catch (e) {
      throw FirebaseAuthTimeoutException("Thao tác này đã hết thời gian");
    } on IOException catch (e) {
      throw FirebaseAuthRemoteDataSourceException(
          "Kiểm tra kết nối Internet của bạn");
    } catch (e) {
      throw FirebaseAuthRemoteDataSourceException(e.toString());
    }
  }

  @override
  Future<String> resetPassword(String email) async {
    try {
      var response = await firebaseAuthConfig.resetPasswordEmail(email);
      return "Thư điện tử đã được gửi đến $email";
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthRemoteDataSourceException("Vui lòng thử lại sau");
    } on TimeoutException catch (e) {
      throw FirebaseAuthTimeoutException("Thao tác này đã hết thời gian");
    } on IOException catch (e) {
      throw FirebaseAuthRemoteDataSourceException(
          "Kiểm tra kết nối Internet của bạn");
    } catch (e) {
      throw FirebaseAuthRemoteDataSourceException(e.toString());
    }
  }
}
