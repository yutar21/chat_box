import 'package:chat/Domain/Models/Room/Room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomDTO {
  String id;
  String name;
  String description;
  String category;
  String type;
  String ownerId;
  List<String> users ;
  int dateTime;

  RoomDTO(
      {required this.id,
      required this.name,
      required this.description,
      required this.category,
      required this.type,
      required this.ownerId,
      required this.users,
      required this.dateTime
  });

  RoomDTO.fromFireStore(Map<String, dynamic> json)
      : this(
            id: json['id'],
            name: json['name'],
            description: json['description'],
            category: json['category'],
            type: json['type'],
            ownerId: json['ownerId'],
            users: List<String>.from(json['users']),
            dateTime:  json['dateTime']
  );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'type': type,
      'ownerId': ownerId,
      'users':users,
      'dateTime': dateTime
    };
  }

  Room toDomain() {
    return Room(
        id: id,
        name: name,
        description: description,
        category: category,
        type: type,
        ownerId: ownerId,
        users: users,
        dateTime: dateTime
    );
  }
}
