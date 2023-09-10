import 'package:chat/widget/Theme/MyTheme.dart';
import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:chat/Domain/UseCase/AddUserToRoomByRoomIdUseCase.dart';
import 'package:chat/Domain/UseCase/GetUserRoomsUseCase.dart';
import 'package:chat/Domain/UseCase/SignOutUseCase.dart';
import 'package:chat/Domain/UseCase/GetPublicRoomsUseCase.dart';
import 'package:chat/Presentation/DI/di.dart';
import 'package:chat/widget/Base/BaseState.dart';
import 'package:chat/Presentation/view/Chat/ChatView.dart';
import 'package:chat/Presentation/view/Create%20Room/CreateRoomView.dart';
import 'package:chat/Presentation/view/GlobalWidgets/CustomTextFormField.dart';
import 'package:chat/Presentation/view/Home/HomeNavigator.dart';
import 'package:chat/Presentation/view/Home/HomeViewModel.dart';
import 'package:chat/Presentation/view/Home/Widgets/BrowseRoomsTab.dart';
import 'package:chat/Presentation/view/Home/Widgets/Drower.dart';
import 'package:chat/Presentation/view/Home/Widgets/MyRoomsTab.dart';
import 'package:chat/Presentation/view/JoinRoom/JoinRoomView.dart';
import 'package:chat/Presentation/view/Login/LoginView.dart';
import 'package:chat/Presentation/view/Search/SearchView.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:floating_action_bubble_custom/floating_action_bubble_custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen, HomeViewModel>
    with SingleTickerProviderStateMixin
    implements HomeNavigator {
  @override
  HomeViewModel initialViewModel() {
    return HomeViewModel(
      SignOutUseCase(injectAuthRepo()),
      GetPublicRoomsUseCase(injectRoomDataRepo()),
      GetUserRoomsUseCase(injectRoomDataRepo()),
      AddUserToRoomByRoomIdUseCase(injectRoomDataRepo(), injectUserRepo()),
    );
  }

  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: animationController,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Stack(
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
          DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  "Trang chủ",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: MyTheme.white),
                ),
                actions: [
                  InkWell(
                      onTap: viewModel!.goToSearchScreen,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Icon(
                          EvaIcons.search,
                          color: MyTheme.white,
                        ),
                      ))
                ],
              ),
              drawer: HomeScreenDrawer(
                user: viewModel!.provider!.user!,
                onSignOutPress: viewModel!.onSignOutPress,
                onCopyIdPress: viewModel!.onCopyIdPress,
              ),
              body: ContainedTabBarView(
                onChange: (index) {
                  viewModel!.changeSelectedTabIndex(index);
                },
                tabBarViewProperties: const TabBarViewProperties(
                    physics: BouncingScrollPhysics()),
                tabBarProperties: const TabBarProperties(
                  indicatorColor: MyTheme.white,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                ),
                tabs: [
                  tabBarButtonWidget("Phòng của tôi"),
                  tabBarButtonWidget("Phòng công khai"),
                ],
                views: [
                  Column(children: [
                    MyRoomsTab(
                        viewModel!.getUserRooms(), viewModel!.goToChatScreen)
                  ]),
                  Column(children: [
                    BrowseRoomsTab(viewModel!.getPublicRooms(),
                        viewModel!.goToJoinRoomScreen)
                  ]),
                ],
              ),
              floatingActionButton: Consumer<HomeViewModel>(
                builder: (context, value, child) => value.selectedTabIndex == 0
                    ? FloatingActionBubble(
                        items: [
                          BubbleMenu(
                              title: "Tạo phòng",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: MyTheme.white),
                              iconColor: MyTheme.white,
                              bubbleColor: MyTheme.blue,
                              icon: EvaIcons.messageCircle,
                              onPressed: value.goToCreateRoomScreen),
                          BubbleMenu(
                              title: "Tham gia",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: MyTheme.white),
                              iconColor: MyTheme.white,
                              bubbleColor: MyTheme.blue,
                              icon: EvaIcons.messageCircle,
                              onPressed: () {
                                viewModel!.showMyModalBottomSheet();
                              }),
                        ],
                        onPressed: () => animationController.isCompleted
                            ? animationController.reverse()
                            : animationController.forward(),
                        iconColor: MyTheme.white,
                        iconData: EvaIcons.messageCircle,
                        backgroundColor: MyTheme.blue,
                        animation: animation,
                      )
                    : FloatingActionBubble(
                        items: [
                          BubbleMenu(
                              title: "Mới",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: MyTheme.white),
                              iconColor: MyTheme.white,
                              bubbleColor: MyTheme.blue,
                              icon: EvaIcons.plus,
                              onPressed: () {
                                viewModel!.sortRoomsByNewRooms();
                              }),
                          BubbleMenu(
                              title: "Phổ biến",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: MyTheme.white),
                              iconColor: MyTheme.white,
                              bubbleColor: MyTheme.blue,
                              icon: EvaIcons.peopleOutline,
                              onPressed: () {
                                viewModel!.sortRoomsByNumberOfMembers();
                              }),
                          BubbleMenu(
                              title: "Cũ nhất",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: MyTheme.white),
                              iconColor: MyTheme.white,
                              bubbleColor: MyTheme.blue,
                              icon: EvaIcons.calendarOutline,
                              onPressed: () {
                                viewModel!.sortRoomsByOldRooms();
                              }),
                        ],
                        onPressed: () => animationController.isCompleted
                            ? animationController.reverse()
                            : animationController.forward(),
                        iconColor: MyTheme.white,
                        iconData: EvaIcons.barChart,
                        backgroundColor: MyTheme.blue,
                        animation: animation,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget tabBarButtonWidget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: MyTheme.white),
      ),
    );
  }

  @override
  void showMyModalBottomSheet(
      {required TextEditingController idController}) async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        MyTextFormField(
                            controller: idController,
                            label: "Nhập ID phòng",
                            inputType: TextInputType.text,
                            validator: viewModel!.bottomSheetIdValidation),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: ElevatedButton(
                              onPressed: viewModel!.joinRoomByRoomId,
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(MyTheme.blue),
                                  elevation: MaterialStateProperty.all(4),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: Text(
                                  "Tham gia",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: MyTheme.white),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        isScrollControlled: true);
  }

  @override
  goToSearchScreen() {
    Navigator.pushNamed(context, SearchView.routeName);
  }

  @override
  goToCreateRoomScreen() {
    Navigator.pushNamed(context, CreateRoomView.routeName);
  }

  @override
  goToLoginScreen() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  goToJoinRoomScreen(Room room) {
    Navigator.pushNamed(context, JoinRoomScreen.routeName, arguments: room);
  }

  @override
  goToChatScreen(Room room) {
    Navigator.pushNamed(context, ChatView.routeName, arguments: room);
  }

  @override
  hideModalBottomSheet() {
    Navigator.pop(context);
  }
}
