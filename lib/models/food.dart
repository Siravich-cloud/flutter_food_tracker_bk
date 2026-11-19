// ignore_for_file: non_constant_identifier_names

class Food {
  String? id;
  String? created_at;
  String? foodDate;
  String? foodMeal;
  String? foodName;
  String? foodPrice;
  String? foodPerson;
  String? foodImageUrl;

  Food({
    this.id,
    this.created_at,
    this.foodDate,
    this.foodMeal,
    this.foodName,
    this.foodPrice,
    this.foodPerson,
    this.foodImageUrl,
  });

  
  Map<String, dynamic> toJson() => {
       
        "foodDate": foodDate,
        "foodMeal": foodMeal,
        "foodName": foodName,
        "foodPrice": double.tryParse(foodPrice ?? ''),
        "foodPerson": int.tryParse(foodPerson ?? ''), 
        "foodImageUrl": foodImageUrl,
      };

 
  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"]?.toString(),
        created_at: json["created_at"]?.toString(),
        foodDate: json["foodDate"]?.toString(),
        foodMeal: json["foodMeal"]?.toString(),
        foodName: json["foodName"]?.toString(),
        foodPrice: json["foodPrice"]?.toString(),
        foodPerson: json["foodPerson"]?.toString(),
        foodImageUrl: json["foodImageUrl"]?.toString(),
      );
}
