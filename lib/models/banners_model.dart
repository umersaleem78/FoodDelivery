class BannersModel {
  String? name;
  String? restaurantName;
  String? image;
  String? time;

  BannersModel({this.name, this.restaurantName, this.image, this.time});

  BannersModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    restaurantName = json['restaurantName'];
    image = json['image'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['restaurantName'] = restaurantName;
    data['image'] = image;
    data['time'] = time;
    return data;
  }
}
