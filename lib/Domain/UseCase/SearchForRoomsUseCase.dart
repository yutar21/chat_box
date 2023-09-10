import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:chat/Domain/presenters/RoomsRepositoryContract.dart';

class SearchForRoomsUseCase {
  RoomDataRepository repository;
  SearchForRoomsUseCase(this.repository);

  Future<List<Room>> invoke(String query) async {
    var response = await repository.getRoomsForSearch(query);
    return response;
  }
}
