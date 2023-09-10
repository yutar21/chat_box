import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:chat/widget/Base/BaseNavigator.dart';

abstract class ChatNavigator extends BaseNavigator {
  goToRoomDetailsScreen(Room room);
}
