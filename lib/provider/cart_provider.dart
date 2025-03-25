import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/injection_container.dart';
import 'package:shop/model/cart_item.dart';
import 'package:shop/repository/cart_repository.dart';

// Cart State Class
class CartState {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? error;

  CartState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  final CartRepository _cartRepository;

  CartNotifier(this._cartRepository) : super(CartState());

  Future<void> fetchCartItems() async {
    try {
      state = state.copyWith(isLoading: true);
      final items = await _cartRepository.getCartItems();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> addToCart(CartItemModel cartItem) async {
    try {
      state = state.copyWith(isLoading: true);
      await _cartRepository.addToCart(cartItem);
      await fetchCartItems();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      state = state.copyWith(isLoading: true);
      await _cartRepository.removeFromCart(productId);
      await fetchCartItems();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> updateQuantity(int productId, int newQuantity) async {
    try {
      state = state.copyWith(isLoading: true);
      await _cartRepository.updateQuantity(productId, newQuantity);
      await fetchCartItems();
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> clearCart() async {
    try {
      state = state.copyWith(isLoading: true);
      await _cartRepository.clearCart();
      state = state.copyWith(items: [], isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  double calculateTotalPrice() {
    return state.items.fold(
      0.0, 
      (total, item) => total + item.totalPrice
    );
  }

  int get totalItemCount => state.items.fold(
    0, 
    (total, item) => total + item.quantity
  );
}

// Provider Setup
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return sl<CartRepository>();
});

final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(repository);
});