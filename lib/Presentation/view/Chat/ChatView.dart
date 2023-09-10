import 'package:chat/Data/Models/Message/MessageDTO.dart';
import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:chat/Domain/UseCase/DeleteRoomUseCase.dart';
import 'package:chat/Domain/UseCase/GetMessagesUseCase.dart';
import 'package:chat/Domain/UseCase/RemoveUserFromRoomUseCase.dart';
import 'package:chat/Domain/UseCase/SendMessageUseCase.dart';
import 'package:chat/Presentation/DI/di.dart';
import 'package:chat/Presentation/view/Chat/ChatNavigator.dart';
import 'package:chat/Presentation/view/Chat/ChatViewModel.dart';
import 'package:chat/Presentation/view/Chat/Widgets/MessageWidget.dart';
import 'package:chat/Presentation/view/RoomDetails/RoomDetailsView.dart';
import 'package:chat/Presentation/view/UpdateRoomDetails/UpdateRoomDetailsView.dart';
import 'package:chat/widget/Base/BaseState.dart';
import 'package:chat/widget/Theme/MyTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  static const String routeName = 'chatScreen';
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends BaseState<ChatView, ChatViewModel>
    implements ChatNavigator {
  @override
  Widget build(BuildContext context) {
    if (viewModel!.room == null) {
      viewModel!.room = ModalRoute.of(context)!.settings.arguments as Room;
    }
    return Stack(
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
          appBar: AppBar(
            title: Text(viewModel!.room!.name),
            actions: [
              PopupMenuButton<Widget>(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                itemBuilder: (context) => [
                  PopupMenuItem(
                      child: InkWell(
                    onTap: () {
                      viewModel!.goToRoomDetailsScreen();
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: [
                          Text("Xem chi tiết phòng"),
                        ],
                      ),
                    ),
                  )),
                  viewModel!.provider!.user!.uid == viewModel!.room!.ownerId
                      ? PopupMenuItem(
                          child: InkWell(
                            onTap: () {
                              viewModel!.showDeleteRoomQuestionMessage();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Row(
                                children: [
                                  Text('Xoá phòng'),
                                ],
                              ),
                            ),
                          ),
                        )
                      : PopupMenuItem(
                          child: InkWell(
                            onTap: () {
                              viewModel!.showExitRoomQuestionMessage();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 12),
                              child: Row(
                                children: [
                                  Text('Thoát phòng'),
                                ],
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                  child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                decoration: BoxDecoration(
                    color: MyTheme.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: MyTheme.black.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ]),
                child: Column(
                  children: [
                    Expanded(
                        child: StreamBuilder<QuerySnapshot<MessageDTO>>(
                      stream: viewModel!.getMessages(viewModel!.room!.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: MyTheme.blue,
                          ));
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text("Không thể tải dữ liệu"));
                        } else {
                          viewModel!.messages = snapshot.data!.docs
                              .map((e) => e.data().toDomain())
                              .toList();
                          viewModel!.sortMessagesByNewTime();
                          if (viewModel!.messages.isEmpty) {
                            return Center(
                                child: Text(
                              "Bắt đầu gửi tin nhắn",
                              style: Theme.of(context).textTheme.displayMedium,
                            ));
                          } else {
                            return ListView.builder(
                              padding: const EdgeInsets.all(10),
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => MessageWidget(
                                  message: viewModel!.messages[index],
                                  uid: viewModel!.provider!.user!.uid),
                              itemCount: viewModel!.messages.length,
                            );
                          }
                        }
                      },
                    )),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              cursorHeight: 20,
                              style: Theme.of(context).textTheme.displayMedium,
                              cursorColor: MyTheme.gray,
                              keyboardType: TextInputType.text,
                              controller: viewModel!.messageController,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    viewModel!.sendMessage(viewModel!.room!.id);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20),
                                    child: Icon(
                                      EvaIcons.paperPlane,
                                      color: MyTheme.blue,
                                    ),
                                  ),
                                ),
                                fillColor: MyTheme.white,
                                filled: true,
                                contentPadding: const EdgeInsets.all(20),
                                hintText: "Gõ một tin nhắn",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: MyTheme.blue,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: MyTheme.blue,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      width: 1,
                                      color: MyTheme.blue,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      width: 2,
                                      color: Colors.red,
                                    )),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      width: 2,
                                      color: Colors.red,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        )
      ],
    );
  }

  @override
  ChatViewModel initialViewModel() {
    return ChatViewModel(
        SendMessageUseCase(injectMessagesRepo()),
        GetMessagesUseCase(injectMessagesRepo()),
        RemoveUserFromRoomUseCase(injectRoomDataRepo(), injectUserRepo()),
        DeleteRoomUseCase(injectRoomDataRepo()));
  }

  @override
  goToRoomDetailsScreen(Room room) {
    Navigator.pushReplacementNamed(context, RoomDetailsView.routeName,
        arguments: room);
  }
}
