class RoomCategory {
  String id;
  String name;
  String image;

  RoomCategory({required this.id, required this.name, required this.image});

  static List<RoomCategory> getAllCategories() {
    return [
      RoomCategory(id: "chat", name: "Trò chuyện", image: "chat.png"),
      RoomCategory(id: "coding", name: "Coding", image: "coding.png"),
      RoomCategory(id: "gaming", name: "Gaming", image: "gaming.png"),
      RoomCategory(id: "music", name: "Âm nhạc", image: "music.png"),
      RoomCategory(id: "movies", name: "Phim", image: "movies.png"),
      RoomCategory(id: "events", name: "Sự kiện", image: "events.png"),
      RoomCategory(id: "art", name: "Nghệ thuật", image: "art.png"),
      RoomCategory(id: "fashion", name: "Thời trang", image: "fashion.png"),
      RoomCategory(id: "global", name: "Toàn cầu", image: "global.png"),
      RoomCategory(id: "news", name: "Tin tức", image: "news.png"),
      RoomCategory(id: "reading", name: "Đọc", image: "reading.png"),
      RoomCategory(
          id: "smartphone",
          name: "Điện thoại thông minh",
          image: "smartphone.png"),
    ];
  }

  static RoomCategory getRoomCategory(String id) {
    var categories = getAllCategories();
    switch (id) {
      case "chat":
        return categories[0];
      case "coding":
        return categories[1];
      case "gaming":
        return categories[2];
      case "music":
        return categories[3];
      case "movies":
        return categories[4];
      case "events":
        return categories[5];
      case "art":
        return categories[6];
      case "fashion":
        return categories[7];
      case "global":
        return categories[8];
      case "news":
        return categories[9];
      case "reading":
        return categories[10];
      case "smartphone":
        return categories[11];
      default:
        return RoomCategory(id: "id", name: "name", image: "image");
    }
  }
}
