import 'package:chat/Data/Models/Room/RoomDTO.dart';
import 'package:chat/Domain/Exception/FirebaseAuthException.dart';
import 'package:chat/Domain/Exception/FirebaseAuthTimeoutException.dart';
import 'package:chat/Domain/Exception/FirebaseFireStoreDatabaseTimeoutException.dart';
import 'package:chat/Domain/Exception/FirebaseFirestoreDatabaseException.dart';
import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:chat/Domain/UseCase/AddUserToRoomByRoomIdUseCase.dart';
import 'package:chat/Domain/UseCase/GetUserRoomsUseCase.dart';
import 'package:chat/Domain/UseCase/SignOutUseCase.dart';
import 'package:chat/Domain/UseCase/GetPublicRoomsUseCase.dart';
import 'package:chat/Presentation/view/Home/HomeNavigator.dart';
import 'package:chat/widget/Base/BaseViewModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends BaseViewModel<HomeNavigator> {
  SignOutUseCase signOutUseCase;
  GetPublicRoomsUseCase getPublicRoomsUseCase;
  GetUserRoomsUseCase getUserRoomsUseCase;
  AddUserToRoomByRoomIdUseCase addUserToRoomByRoomIdUseCase;
  HomeViewModel(this.signOutUseCase, this.getPublicRoomsUseCase,
      this.getUserRoomsUseCase, this.addUserToRoomByRoomIdUseCase);
  TextEditingController idController = TextEditingController();

  List<Room> myRooms = [];
  List<Room> browseRooms = [];

  int comingRooms = 0;
  // to control the action and the title of the floating action button
  int selectedTabIndex = 0;
  void changeSelectedTabIndex(int index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  void goToSearchScreen() {
    navigator!.goToSearchScreen();
  }

  void goToCreateRoomScreen() {
    navigator!.goToCreateRoomScreen();
  }

  void onCopyIdPress() {
    navigator!.showNotification();
  }

  void goToJoinRoomScreen(Room room) {
    navigator!.goToJoinRoomScreen(room);
  }

  void goToChatScreen(Room room) {
    navigator!.goToChatScreen(room);
  }

  void showMyModalBottomSheet() {
    navigator!.showMyModalBottomSheet(idController: idController);
  }

  void onSignOutPress() async {
    navigator!.showQuestionMessage(
        message: "Bạn có chắc chắn muốn đăng xuất không?",
        posActionTitle: "Ok",
        posAction: signOut,
        negativeActionTitle: "Huỷ");
  }

  void signOut() async {
    navigator!.showLoading("Đăng xuất bạn");
    try {
      await signOutUseCase.invoke();
      provider!.removeUser();
      navigator!.removeContext();
      navigator!.goToLoginScreen();
    } catch (e) {
      navigator!.removeContext();
      if (e is FirebaseAuthRemoteDataSourceException) {
        navigator!.showFailMessage(
            message: e.errorMessage, posActionTitle: "Thử lại");
      } else if (e is FirebaseAuthTimeoutException) {
        navigator!.showFailMessage(
            message: e.errorMessage, posActionTitle: "Thử lại");
      } else {
        navigator!
            .showFailMessage(message: e.toString(), posActionTitle: "Thử lại");
      }
    }
  }

  String? bottomSheetIdValidation(String id) {
    if (id.isEmpty) {
      return "phần bắt buộc";
    } else {
      return null;
    }
  }

  void joinRoomByRoomId() async {
    navigator!.showLoading("Đang tham gia...");
    try {
      var response = await addUserToRoomByRoomIdUseCase.invoke(
          idController.text, provider!.user!);
      navigator!.removeContext();
      if (response == "Bạn đã ở trong phòng này") {
        navigator!.showFailMessage(
            message: response,
            posActionTitle: 'Ok',
            posAction: hideModalBottomSheet);
      } else {
        navigator!.showSuccessMessage(
            message: response,
            posActionTitle: 'Ok',
            posAction: hideModalBottomSheet);
      }
      idController.text = '';
    } catch (e) {
      navigator!.removeContext();
      if (e is FirebaseFireStoreDatabaseTimeoutException) {
        navigator!
            .showFailMessage(message: e.errorMessage, posActionTitle: "Ok");
      } else if (e is FirebaseFireStoreDatabaseException) {
        navigator!
            .showFailMessage(message: e.errorMessage, posActionTitle: "Ok");
      } else {
        navigator!.showFailMessage(message: e.toString(), posActionTitle: "Ok");
      }
    }
  }

  void hideModalBottomSheet() {
    navigator!.hideModalBottomSheet();
  }

  Stream<QuerySnapshot<RoomDTO>> getPublicRooms() {
    return getPublicRoomsUseCase.invoke();
  }

  Stream<QuerySnapshot<RoomDTO>> getUserRooms() {
    return getUserRoomsUseCase.invoke(provider!.user!.uid);
  }

  void removeUsersJoinedRoom() {
    for (int i = 0; i < browseRooms.length; i++) {
      if (browseRooms[i].users.contains(provider!.user!.uid)) {
        browseRooms.removeWhere((element) => element.id == browseRooms[i].id);
        i--;
      }
    }
    for (int i = 0; i < browseRooms.length - 1; i++) {
      var swapped = false;
      for (int j = 0; j < browseRooms.length - i - 1; j++) {
        if (browseRooms[j].dateTime < browseRooms[j + 1].dateTime) {
          var temp = browseRooms[j];
          browseRooms[j] = browseRooms[j + 1];
          browseRooms[j + 1] = temp;
          swapped = true;
        }
      }
      if (swapped == false) {
        break;
      }
    }
  }

  List<Room> removeUsersJoinedRoomForNewRooms(List<Room> browseRooms) {
    for (int i = 0; i < browseRooms.length; i++) {
      if (browseRooms[i].users.contains(provider!.user!.uid)) {
        browseRooms.removeWhere((element) => element.id == browseRooms[i].id);
        i--;
      }
    }
    for (int i = 0; i < browseRooms.length - 1; i++) {
      var swapped = false;
      for (int j = 0; j < browseRooms.length - i - 1; j++) {
        if (browseRooms[j].dateTime < browseRooms[j + 1].dateTime) {
          var temp = browseRooms[j];
          browseRooms[j] = browseRooms[j + 1];
          browseRooms[j + 1] = temp;
          swapped = true;
        }
      }
      if (swapped == false) {
        break;
      }
    }
    return browseRooms;
  }

  void sortRoomsByOldRooms() {
    var rooms = browseRooms;
    for (int i = 0; i < rooms.length - 1; i++) {
      var swapped = false;
      for (int j = 0; j < rooms.length - i - 1; j++) {
        if (rooms[j].dateTime > rooms[j + 1].dateTime) {
          var temp = rooms[j];
          rooms[j] = rooms[j + 1];
          rooms[j + 1] = temp;
          swapped = true;
        }
      }
      if (swapped == false) {
        break;
      }
    }
    browseRooms = rooms;
    notifyListeners();
  }

  void sortRoomsByNewRooms() {
    var rooms = browseRooms;
    for (int i = 0; i < rooms.length - 1; i++) {
      var swapped = false;
      for (int j = 0; j < rooms.length - i - 1; j++) {
        if (rooms[j].dateTime < rooms[j + 1].dateTime) {
          var temp = rooms[j];
          rooms[j] = rooms[j + 1];
          rooms[j + 1] = temp;
          swapped = true;
        }
      }
      if (swapped == false) {
        break;
      }
    }
    browseRooms = rooms;
    notifyListeners();
  }

  void sortRoomsByNumberOfMembers() {
    var rooms = browseRooms;

    for (int i = 0; i < rooms.length - 1; i++) {
      var swapped = false;
      for (int j = 0; j < rooms.length - i - 1; j++) {
        if (rooms[j].users.length < rooms[j + 1].users.length) {
          var temp = rooms[j];
          rooms[j] = rooms[j + 1];
          rooms[j + 1] = temp;
          swapped = true;
        }
      }
      if (swapped == false) {
        break;
      }
    }
    browseRooms = rooms;
    notifyListeners();
  }
}
