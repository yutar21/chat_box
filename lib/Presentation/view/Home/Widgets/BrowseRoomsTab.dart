import 'package:chat/Data/Models/Room/RoomDTO.dart';
import 'package:chat/Presentation/view/GlobalWidgets/CardWidget.dart';
import 'package:chat/widget/Theme/MyTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../HomeViewModel.dart';

class BrowseRoomsTab extends StatefulWidget {
  Stream<QuerySnapshot<RoomDTO>> rooms;
  Function navigate;
  BrowseRoomsTab(this.rooms, this.navigate);

  @override
  State<BrowseRoomsTab> createState() => _BrowseRoomsTabState();
}

class _BrowseRoomsTabState extends State<BrowseRoomsTab> {
  @override
  Widget build(BuildContext context) {
    HomeViewModel viewModel = Provider.of<HomeViewModel>(context);
    return Expanded(
      child: StreamBuilder<QuerySnapshot<RoomDTO>>(
          stream: widget.rooms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: MyTheme.blue,
              ));
            } else if (snapshot.hasError) {
              return const Center(child: Text("Không thể tải dữ liệu"));
            } else {
              var newRooms =
                  snapshot.data!.docs.map((e) => e.data().toDomain()).toList();
              newRooms = viewModel.removeUsersJoinedRoomForNewRooms(newRooms);
              if (viewModel.browseRooms.isEmpty ||
                  viewModel.comingRooms != newRooms.length) {
                viewModel.comingRooms = newRooms.length;
                viewModel.browseRooms = snapshot.data!.docs
                    .map((e) => e.data().toDomain())
                    .toList();
                viewModel.removeUsersJoinedRoom();
              }
              if (viewModel.browseRooms.isEmpty) {
                return Center(
                  child: Text(
                    "Chưa có phòng nào",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: MyTheme.blue, fontWeight: FontWeight.w500),
                  ),
                );
              } else {
                return Consumer<HomeViewModel>(
                  builder: (context, value, child) => GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.77),
                    padding: const EdgeInsets.all(20),
                    itemCount: value.browseRooms.length,
                    itemBuilder: (context, index) => CardWidget(
                        room: value.browseRooms[index],
                        navigate: widget.navigate),
                  ),
                );
              }
            }
          }),
    );
  }
}
