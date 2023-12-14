import 'package:fit_me/models/nutrients.dart';

class Product {
  String? foodId;
  String? label;
  String? knownAs;
  Nutrients? nutrients;
  String? category;
  String? categoryLabel;
  String? image;
  bool? isSelected;

  Product(
      {this.foodId,
      this.label,
      this.knownAs,
      this.nutrients,
      this.category,
      this.categoryLabel,
      this.image,
      this.isSelected = false});

  Product.fromJson(Map<String, dynamic> json) {
    foodId = json['foodId'];
    label = json['label'];
    knownAs = json['knownAs'];
    nutrients = json['nutrients'] != null
        ? Nutrients.fromJson(json['nutrients'])
        : null;
    category = json['category'];
    categoryLabel = json['categoryLabel'];
    image = json['image'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['foodId'] = foodId;
    data['label'] = label;
    data['knownAs'] = knownAs;
    if (nutrients != null) {
      data['nutrients'] = nutrients!.toJson();
    }
    data['category'] = category;
    data['categoryLabel'] = categoryLabel;
    data['image'] = image;
    return data;
  }
}
