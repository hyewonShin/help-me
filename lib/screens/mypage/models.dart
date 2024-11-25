class Give {
  final int giveId;
  final int userId;
  final String title;
  final String desc;
  final int price;
  final String image;

  Give({
    required this.giveId,
    required this.userId,
    required this.title,
    required this.desc,
    required this.price,
    required this.image,
  });

  factory Give.fromJson(Map<String, dynamic> json) {
    return Give(
      giveId: json['give_id'],
      userId: json['user_id'],
      title: json['title'],
      desc: json['desc'],
      price: json['price'],
      image: json['image'],
    );
  }
}

class Ask {
  final int askId;
  final int userId;
  final String title;
  final String desc;
  final int price;

  Ask({
    required this.askId,
    required this.userId,
    required this.title,
    required this.desc,
    required this.price,
  });

  factory Ask.fromJson(Map<String, dynamic> json) {
    return Ask(
      askId: json['ask_id'],
      userId: json['user_id'],
      title: json['title'],
      desc: json['desc'],
      price: json['price'],
    );
  }
}

class Users {
  final int userId;
  final String name;
  final List<Map<String, dynamic>> giveCart;
  final List<Map<String, dynamic>> askCart;

  Users({
    required this.userId,
    required this.name,
    required this.giveCart,
    required this.askCart,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        userId: json['user_id'],
        name: json['name'],
        giveCart: json['give'],
        askCart: json['ask']);
  }

  // JSON으로 변환하는 toJson() 메서드 추가
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'give': giveCart,
      'ask': askCart,
    };
  }
}

class GiveCartList {
  int giveId;
  String username;
  String title;
  int quantity;
  int price;
  String image;
  GiveCartList(this.giveId, this.username, this.title, this.quantity,
      this.price, this.image);
}
