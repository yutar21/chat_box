import 'package:chat/Domain/UseCase/ResetPasswordUseCase.dart';
import 'package:chat/Presentation/DI/di.dart';
import 'package:chat/Presentation/view/GlobalWidgets/CustomTextFormField.dart';
import 'package:chat/Presentation/view/ResetPassword/ResetPasswordNavigator.dart';
import 'package:chat/Presentation/view/ResetPassword/ResetPasswordViewModel.dart';
import 'package:chat/widget/Base/BaseState.dart';
import 'package:chat/widget/Theme/MyTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = 'resetScreen';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends BaseState<ResetPasswordScreen, ResetPasswordViewModel>
    implements ResetPasswordNavigator {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: double.infinity,
        width: double.infinity,
        color: MyTheme.white,
      ),
      Image.asset(
        'assets/images/bgShape.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Scaffold(
        appBar: AppBar(
          title: const Text(
            "Lấy lại mật khẩu",
            style: TextStyle(color: MyTheme.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/SVG/Forgot password.svg",
                width: 300,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Quên mật khẩu?",
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: MyTheme.blue),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: Text(
                  textAlign: TextAlign.center,
                  "Đừng lo lắng! nó xảy ra \nVui lòng nhập email được liên kết với tài khoản của bạn ",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: MyTheme.black),
                ),
              ),
              MyTextFormField(
                controller: viewModel!.emailResetController,
                inputType: TextInputType.emailAddress,
                label: "Địa chỉ email",
                validator: viewModel!.emailValidation,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                child: ElevatedButton(
                    onPressed: viewModel!.resetPassword,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Text(
                        "Gửi mã",
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: MyTheme.white),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  @override
  ResetPasswordViewModel initialViewModel() {
    return ResetPasswordViewModel(ResetPasswordUseCase(injectAuthRepo()));
  }
}
