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
  String? mealType;
  DateTime? date;

  Product({
    this.foodId,
    this.label,
    this.knownAs,
    this.nutrients,
    this.category,
    this.categoryLabel,
    this.image,
    this.isSelected = false,
    this.mealType,
    this.date,
  });

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
    mealType = json['mealType'];

    // Parse the date from the JSON and convert it to a DateTime object
    date = DateTime.tryParse(json['date'] ??
        ''); // Replace 'date' with the actual date field in your JSON
  }

  Map<String, dynamic> toJson() {
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
    data['mealType'] = mealType;

    // Convert DateTime to ISO 8601 format and store it in the JSON
    data['date'] = date?.toIso8601String();

    return data;
  }
}
