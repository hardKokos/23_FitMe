class Nutrients {
  double? kcal;
  double? protein;
  double? fat;
  double? carbs;
  double? fiber;

  Nutrients({this.kcal, this.protein, this.fat, this.carbs, this.fiber});

  Nutrients.fromJson(Map<String, dynamic> json) {
    kcal = json['ENERC_KCAL'];
    protein = json['PROCNT'];
    fat = json['FAT'];
    carbs = json['CHOCDF'];
    fiber = json['FIBTG'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ENERC_KCAL'] = kcal;
    data['PROCNT'] = protein;
    data['FAT'] = fat;
    data['CHOCDF'] = carbs;
    data['FIBTG'] = fiber;
    return data;
  }
}
