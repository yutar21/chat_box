import 'package:chat/Data/DataSource/FirebaseAuthRemoteDataSourceImpl.dart';
import 'package:chat/Data/DataSource/FirebaseUsersRemoteDataSourceImpl.dart';
import 'package:chat/Data/DataSource/MessagesRemoteDataSourceImpl.dart';
import 'package:chat/Data/DataSource/RoomDataRemoteDataSourceImpl.dart';
import 'package:chat/Data/DataSource/UsersFirebaseRemoteDataSourceImpl.dart';
import 'package:chat/Data/Firebase/ErrorHandeler.dart';
import 'package:chat/Data/Firebase/FirebaseAuth.dart';
import 'package:chat/Data/Firebase/MessagesDatabase.dart';
import 'package:chat/Data/Firebase/RoomUsersDataBase.dart';
import 'package:chat/Data/Firebase/RoomsDatabase.dart';
import 'package:chat/Data/Firebase/UsersDataBase.dart';
import 'package:chat/Data/presenters/FirebaseAuthRepositoryImpl.dart';
import 'package:chat/Data/presenters/MessagesRepositoryImpl.dart';
import 'package:chat/Data/presenters/RoomDataRepositoryImpl.dart';
import 'package:chat/Data/presenters/UsersRepositoryImpl.dart';
import 'package:chat/Domain/presenters/FirebaseAuthContract.dart';
import 'package:chat/Domain/presenters/MessagesRepositoryContract.dart';
import 'package:chat/Domain/presenters/RoomsRepositoryContract.dart';
import 'package:chat/Domain/presenters/UsersRepositoryContract.dart';

// get error handler
ErrorHandler getErrorHandler() {
  return ErrorHandler.getErrorHandler();
}

// the dependency injection of the Firebase Auth Repository
FirebaseAuthConfig getFirebaseAuthConfig() {
  return FirebaseAuthConfig.getFirebaseAuthConfig();
}

UsersDataBase getUserDataBase() {
  return UsersDataBase.getUserDatabaseInstance();
}

FirebaseUsersRemoteDataSource getFirebaseUsersRemoteDataSource(
    UsersDataBase usersDataBase, ErrorHandler errorHandler) {
  return FirebaseUsersRemoteDataSourceImpl(usersDataBase, errorHandler);
}

FirebaseAuthRemoteDataSource getFirebaseAuthRemoteDataSource(
  FirebaseAuthConfig firebaseAuthConfig,
  ErrorHandler errorHandler,
) {
  return FirebaseAuthRemoteDataSourceImpl(firebaseAuthConfig, errorHandler);
}

FirebaseAuthRepository getFirebaseAuthRepository(
    FirebaseAuthRemoteDataSource remoteDataSource,
    FirebaseUsersRemoteDataSource usersRemoteDataSource) {
  return FirebaseAuthRepositoryImpl(remoteDataSource, usersRemoteDataSource);
}

FirebaseAuthRepository injectAuthRepo() {
  return getFirebaseAuthRepository(
      getFirebaseAuthRemoteDataSource(
          getFirebaseAuthConfig(), getErrorHandler()),
      getFirebaseUsersRemoteDataSource(getUserDataBase(), getErrorHandler()));
}

// the dependency injection of the Rooms Database
RoomsDatabase getRoomsDatabase() {
  return RoomsDatabase.getRoomDatabase();
}

RoomDataRemoteDataSource getRoomDataRemoteDataSource(
    RoomsDatabase database, ErrorHandler errorHandler) {
  return RoomDataRemoteDataSourceImpl(database, errorHandler);
}

RoomDataRepository getRoomDataRepository(RoomDataRemoteDataSource dataSource) {
  return RoomDataRepositoryImpl(dataSource);
}

RoomDataRepository injectRoomDataRepo() {
  return getRoomDataRepository(
      getRoomDataRemoteDataSource(getRoomsDatabase(), getErrorHandler()));
}

// the dependency injection of the Messages Database
MessagesDatabase getMessagesDatabase() {
  return MessagesDatabase.getMessagesDatabase();
}

MessagesRemoteDataSource getMessagesRemoteDataSource(
    MessagesDatabase database, ErrorHandler errorHandler) {
  return MessagesRemoteDataSourceImpl(database, errorHandler);
}

MessagesRepository getMessagesRepository(MessagesRemoteDataSource dataSource) {
  return MessagesRepositoryImpl(dataSource);
}

MessagesRepository injectMessagesRepo() {
  return getMessagesRepository(
      getMessagesRemoteDataSource(getMessagesDatabase(), getErrorHandler()));
}

// inject users repo
RoomUsersDatabase getRoomUserDataBase() {
  return RoomUsersDatabase.getRoomUsersDatabase();
}

UsersFirebaseRemoteDataSource getUsersFirebaseRemoteDataSource(
    RoomUsersDatabase database, ErrorHandler errorHandler) {
  return UsersFirebaseRemoteDataSourceImpl(database, errorHandler);
}

UsersRepository getUsersRepository(
    UsersFirebaseRemoteDataSource remoteDataSource) {
  return UsersRepositoryImpl(remoteDataSource);
}

UsersRepository injectUserRepo() {
  return getUsersRepository(getUsersFirebaseRemoteDataSource(
      getRoomUserDataBase(), getErrorHandler()));
}
