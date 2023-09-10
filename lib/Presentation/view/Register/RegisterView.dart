import 'package:chat/Domain/UseCase/CreateAccountUseCase.dart';
import 'package:chat/Presentation/DI/di.dart';
import 'package:chat/Presentation/view/GlobalWidgets/CustomTextFormField.dart';
import 'package:chat/Presentation/view/Home/HomeView.dart';
import 'package:chat/Presentation/view/Login/LoginView.dart';
import 'package:chat/Presentation/view/Register/RegisterNavigator.dart';
import 'package:chat/Presentation/view/Register/RegisterViewModel.dart';
import 'package:chat/widget/Base/BaseState.dart';
import 'package:chat/widget/Theme/MyTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends BaseState<RegisterScreen, RegisterViewModel>
    implements RegisterNavigator {
  @override
  RegisterViewModel initialViewModel() {
    return RegisterViewModel(CreateAccountUseCase(injectAuthRepo()));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (context) => viewModel!,
      child: Consumer<RegisterViewModel>(
        builder: (context, value, child) => Stack(
          children: [
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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Center(
                          child: Text(
                        "Tạo tài khoản",
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(color: MyTheme.white),
                      )),
                    ),
                    Form(
                        key: value.fromKey,
                        child: Column(
                          children: [
                            // the text Fields
                            MyTextFormField(
                              label: "Họ tên",
                              controller: value.nameController,
                              inputType: TextInputType.name,
                              validator: value.nameValidation,
                            ),
                            MyTextFormField(
                              label: "Email",
                              controller: value.emailController,
                              inputType: TextInputType.emailAddress,
                              validator: value.emailValidation,
                            ),
                            MyPasswordTextFormField(
                              label: "Password",
                              controller: value.passwordController,
                              inputType: TextInputType.visiblePassword,
                              validator: value.passwordValidation,
                            ),
                            MyPasswordTextFormField(
                              label: "Nhập lại Password",
                              controller: value.passwordConfirmationController,
                              inputType: TextInputType.visiblePassword,
                              validator: value.passwordValidation,
                            ),
                            // the create account button in the end of the screen
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                  onPressed: value.register,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Tạo tài khoản",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: MyTheme.white),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: MyTheme.white,
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Bạn đã có tài khoản ?",
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                TextButton(
                                  onPressed: value.goToLoginScreen,
                                  child: Text(
                                    "Đăng nhập!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: MyTheme.blue),
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  goToHomeScreen() {
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  goToLoginScreen() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }
}
