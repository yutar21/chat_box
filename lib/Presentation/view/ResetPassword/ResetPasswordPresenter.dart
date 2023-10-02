import 'package:chat/Domain/Exception/FirebaseAuthException.dart';
import 'package:chat/Domain/Exception/FirebaseAuthTimeoutException.dart';
import 'package:chat/Domain/UseCase/ResetPasswordUseCase.dart';
import 'package:chat/Presentation/view/ResetPassword/ResetPasswordNavigator.dart';
import 'package:chat/widget/Base/BaseViewModel.dart';
import 'package:flutter/material.dart';

class ResetPasswordViewModel extends BaseViewModel<ResetPasswordNavigator> {
  TextEditingController emailResetController = TextEditingController();
  ResetPasswordUseCase useCase;
  ResetPasswordViewModel(this.useCase);
  String? emailValidation(String input) {
    if (input.isEmpty) {
      return "Email không thể để trống";
    } else if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
            r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(input)) {
      return "Vui lòng nhập email hợp lệ";
    }
    return null;
  }

  void resetPassword() async {
    navigator!.showLoading("Gửi email");
    try {
      var response = await useCase.invoke(emailResetController.text);
      navigator!.removeContext();
      navigator!.showSuccessMessage(
          message: "Email đã được gửi thành công", posActionTitle: "ok");
    } catch (e) {
      navigator!.removeContext();
      if (e is FirebaseAuthRemoteDataSourceException) {
        navigator!.showFailMessage(
            message: "Email không chính xác!", posActionTitle: "thử lại");
      } else if (e is FirebaseAuthTimeoutException) {
        navigator!.showFailMessage(
            message: "Email không chính xác!", posActionTitle: "thử lại");
      } else {
        navigator!
            .showFailMessage(message: e.toString(), posActionTitle: "thử lại");
      }
    }
  }
}
