import 'package:chat/Domain/Exception/FirebaseFireStoreDatabaseTimeoutException.dart';
import 'package:chat/Domain/Exception/FirebaseFirestoreDatabaseException.dart';
import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:chat/Domain/UseCase/AddUserToRoomUseCase.dart';
import 'package:chat/Presentation/view/JoinRoom/JoinRoomNavigator.dart';
import 'package:chat/widget/Base/BaseViewModel.dart';

class JoinRoomViewModel extends BaseViewModel<JoinRoomNavigator> {
  AddUserToRoomUseCase addUserToRoomUseCase;
  JoinRoomViewModel(this.addUserToRoomUseCase);

  void joinRoom(Room room) async {
    navigator!.showLoading("Đang vào...");
    try {
      var response = await addUserToRoomUseCase.invoke(room, provider!.user!);
      navigator!.removeContext();
      navigator!.showSuccessMessage(
          message: response, posAction: goToChatScreen, posActionTitle: "Ok");
    } catch (e) {
      navigator!.removeContext();
      if (e is FirebaseFireStoreDatabaseTimeoutException) {
        navigator!.showFailMessage(
            message: e.errorMessage, posActionTitle: "Thử lại");
      } else if (e is FirebaseFireStoreDatabaseException) {
        navigator!.showFailMessage(
            message: e.errorMessage, posActionTitle: "Thử lại");
      } else {
        navigator!
            .showFailMessage(message: e.toString(), posActionTitle: "Thử lại");
      }
    }
  }

  void goToChatScreen() {
    navigator!.goToChatRoom();
  }
}
