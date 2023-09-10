import 'package:chat/Domain/Exception/FirebaseAuthException.dart';
import 'package:chat/Domain/Exception/FirebaseAuthTimeoutException.dart';
import 'package:chat/Domain/UseCase/CreateAccountUseCase.dart';
import 'package:chat/Presentation/view/Register/RegisterNavigator.dart';
import 'package:chat/widget/Base/BaseViewModel.dart';
import 'package:flutter/material.dart';

class RegisterViewModel extends BaseViewModel<RegisterNavigator> {
  CreateAccountUseCase useCase;
  RegisterViewModel(this.useCase);

  final fromKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  // validate on the name if it is not empty and doesn't contain ant spacial characters
  String? nameValidation(String name) {
    if (name.isEmpty) {
      return "Họ tên không thể để trống";
    } else if (RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%-]').hasMatch(name)) {
      return "Tên không hợp lệ";
    } else {
      return null;
    }
  }

  // validate on the email form
  String? emailValidation(String input) {
    if (input.isEmpty) {
      return "Email không được để trống";
    } else if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
            r"@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(input)) {
      return "Vui lòng nhập email hợp lệ";
    }
    return null;
  }

  // validate the password is not less than 8 chars
  String? passwordValidation(String input) {
    if (input.isEmpty) {
      return "Mật khẩu không thể trống";
    } else if (input.length < 8) {
      return "Mật khẩu phải nhiều hơn 8 ký tự";
    }
    return null;
  }

  void register() async {
    if (fromKey.currentState!.validate()) {
      navigator!.showLoading("Đang tạo tài khoản của bạn");
      if (passwordController.text == passwordConfirmationController.text) {
        try {
          var response = await useCase.invoke(
              email: emailController.text,
              name: nameController.text,
              password: passwordController.text);
          provider!.updateUser(response);
          navigator!.removeContext();
          navigator!.showSuccessMessage(
              message: "Tài khoản được tạo thành công",
              posActionTitle: "Ok",
              posAction: goToHomeScreen);
        } catch (e) {
          navigator!.removeContext();
          if (e is FirebaseAuthRemoteDataSourceException) {
            navigator!.showFailMessage(
                message: e.errorMessage, posActionTitle: "Thử lại");
          } else if (e is FirebaseAuthTimeoutException) {
            navigator!.showFailMessage(
                message: e.errorMessage, posActionTitle: "Thử lại");
          } else {
            navigator!.showFailMessage(
                message: e.toString(), posActionTitle: "Thử lại");
          }
        }
      } else {
        navigator!.removeContext();
        navigator!.showFailMessage(
            message: "Mật khẩu không khớp", posActionTitle: "thử lại");
      }
    }
  }

  void goToHomeScreen() {
    navigator!.goToHomeScreen();
  }

  void goToLoginScreen() {
    navigator!.goToLoginScreen();
  }
}
