import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:chat/Domain/Models/User/Users.dart';
import 'package:chat/widget/Base/BaseNavigator.dart';

abstract class RoomDetailsNavigator extends BaseNavigator {
  showMyModalBottomSheetWidget(List<Users> users);
  goToUpdateRoomDetailsScreen(Room room);
}
