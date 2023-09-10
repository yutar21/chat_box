import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:chat/Domain/presenters/RoomsRepositoryContract.dart';

class UpdateRoomUseCase {
  RoomDataRepository repository;
  UpdateRoomUseCase(this.repository);

  Future<void> invoke(Room room) async {
    await repository.updateRoomData(room);
  }
}
