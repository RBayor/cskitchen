class Purchase {
  final String foodName;
  final String foodPrice;
  final String foodQuantity;
  final String foodImg;
  final String foodDetail;

  Purchase({
    this.foodName,
    this.foodPrice,
    this.foodQuantity,
    this.foodImg,
    this.foodDetail,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      foodName: json["foodName"] ?? "",
      foodPrice: json["foodPrice"] ?? "",
      foodQuantity: json["foodQuantity"] ?? "",
      foodImg: json["foodImg"] ?? "",
      foodDetail: json["foodDetail"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foodName": this.foodName,
      "foodPrice": this.foodPrice,
      "foodQuantity": this.foodQuantity,
      "foodImg": this.foodImg,
      "foodDetail": this.foodDetail,
    };
  }
}
