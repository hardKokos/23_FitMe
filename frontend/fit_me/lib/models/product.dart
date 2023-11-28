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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['foodId'] = this.foodId;
    data['label'] = this.label;
    data['knownAs'] = this.knownAs;
    if (this.nutrients != null) {
      data['nutrients'] = this.nutrients!.toJson();
    }
    data['category'] = this.category;
    data['categoryLabel'] = this.categoryLabel;
    data['image'] = this.image;
    return data;
  }
}
