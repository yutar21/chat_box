import 'package:chat/Domain/UseCase/LoginAccountUseCase.dart';
import 'package:chat/Domain/UseCase/SignInWithGoogleUseCase.dart';
import 'package:chat/Presentation/DI/di.dart';
import 'package:chat/Presentation/view/GlobalWidgets/CustomTextFormField.dart';
import 'package:chat/Presentation/view/Home/HomeView.dart';
import 'package:chat/Presentation/view/Login/LoginNavigator.dart';
import 'package:chat/Presentation/view/Login/LoginViewModel.dart';
import 'package:chat/Presentation/view/ResetPassword/ResetPasswordView.dart';
import 'package:chat/Presentation/view/Register/RegisterView.dart';
import 'package:chat/widget/Base/BaseState.dart';
import 'package:chat/widget/Theme/MyTheme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen, LoginViewModel>
    implements LoginNavigator {
  @override
  LoginViewModel initialViewModel() {
    return LoginViewModel(LoginAccountUseCase(injectAuthRepo()),
        SignInWithGoogleUseCase(injectAuthRepo()));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Consumer<LoginViewModel>(
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
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: const Text("Đăng nhập"),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Chào mừng trở lại!',
                        style: Theme.of(context).textTheme.displayLarge!,
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(20),
                        child: InkWell(
                            onTap: value.loginWithGoogle,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyTheme.gray.withOpacity(0.5),
                                      offset: const Offset(0, 3),
                                      blurRadius: 10,
                                    )
                                  ]),
                              child: const Icon(
                                EvaIcons.google,
                                color: Colors.blue,
                              ),
                            ))),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 2,
                              color: MyTheme.black.withOpacity(0.5),
                            ),
                          ),
                          Text(
                            "or",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              height: 2,
                              color: MyTheme.black.withOpacity(0.5),
                            ),
                          )
                        ],
                      ),
                    ),
                    Form(
                        key: value.formKey,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: goToResetScreen,
                                      child: Text(
                                        "Quên mật khẩu",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              color:
                                                  MyTheme.blue.withOpacity(0.8),
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ))
                                ],
                              ),
                            ),
                            // the create account button in the end of the screen
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: ElevatedButton(
                                  onPressed: value.login,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Đăng nhập",
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
                                  "Không có tài khoản?",
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                TextButton(
                                  onPressed: value.goToRegisterScreen,
                                  child: Text(
                                    "Đăng ký ngay!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: MyTheme.blue),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )
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
  goToRegisterScreen() {
    Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
  }

  @override
  goToResetScreen() {
    Navigator.pushNamed(context, ResetPasswordScreen.routeName);
  }
}
