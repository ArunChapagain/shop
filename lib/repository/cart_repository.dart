import 'package:hive/hive.dart';
import 'package:shop/model/cart_item.dart';


class CartRepository {
  static const String _cartBoxName = 'cart_box';

  Future<Box<CartItemModel>> _openBox() async {
    return await Hive.openBox<CartItemModel>(_cartBoxName);
  }

  Future<void> addToCart(CartItemModel cartItem) async {
    final box = await _openBox();
    final existingItemIndex = box.values.toList().indexWhere(
        (item) => item.productId == cartItem.productId);

    if (existingItemIndex != -1) {
      // Update existing item quantity
      final existingItem = box.getAt(existingItemIndex)!;
      existingItem.quantity += cartItem.quantity;
      await box.putAt(existingItemIndex, existingItem);
    } else {
      // Add new item
      await box.add(cartItem);
    }
  }

  Future<void> removeFromCart(int productId) async {
    final box = await _openBox();
    final itemToRemove = box.values.firstWhere(
        (item) => item.productId == productId, 
        orElse: () => throw Exception('Item not found'));
    
    await itemToRemove.delete();
  }

  Future<void> updateQuantity(int productId, int newQuantity) async {
    final box = await _openBox();
    final itemIndex = box.values.toList().indexWhere(
        (item) => item.productId == productId);

    if (itemIndex != -1) {
      final item = box.getAt(itemIndex)!;
      item.quantity = newQuantity;
      await box.putAt(itemIndex, item);
    }
  }

  Future<List<CartItemModel>> getCartItems() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> clearCart() async {
    final box = await _openBox();
    await box.clear();
  }
}