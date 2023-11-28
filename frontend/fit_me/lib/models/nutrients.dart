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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ENERC_KCAL'] = this.kcal;
    data['PROCNT'] = this.protein;
    data['FAT'] = this.fat;
    data['CHOCDF'] = this.carbs;
    data['FIBTG'] = this.fiber;
    return data;
  }
}
