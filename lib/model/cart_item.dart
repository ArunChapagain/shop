import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String brand;

   @HiveField(4)
  final String thumbnail;


  @HiveField(5)
  int quantity;

  @HiveField(6)
  final double? discountPercentage;

  CartItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.brand,
    required this.thumbnail,
    this.quantity = 1,
    this.discountPercentage,
  });

  double get totalPrice => quantity * (price - (price * (discountPercentage ?? 0) / 100));
}