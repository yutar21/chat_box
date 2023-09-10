import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:chat/Domain/Models/User/Users.dart';
import 'package:chat/Domain/presenters/RoomsRepositoryContract.dart';
import 'package:chat/Domain/presenters/UsersRepositoryContract.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddUserToRoomUseCase {
  RoomDataRepository repository;
  UsersRepository usersRepository;
  AddUserToRoomUseCase(this.repository, this.usersRepository);

  Future<String> invoke(Room room, User user) async {
    room.users.add(user.uid);
    var response = await repository.updateRoomMembers(room);
    var userResponse = await usersRepository.addUser(
        room.id,
        Users(
            uid: user.uid,
            name: user.displayName!,
            email: user.email!,
            password: "không xác định"));

    return response;
  }
}
