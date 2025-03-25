import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/repository/get_product_repository.dart';
import 'package:shop/injection_container.dart';

import 'package:shop/model/product.dart';

class ProductState {
  final List<Product> products;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentSkip;
  final int limit;

  ProductState({
    this.products = const [],
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentSkip = 0,
    this.limit = 20,
  });

  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentSkip,
    int? limit,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentSkip: currentSkip ?? this.currentSkip,
      limit: limit ?? this.limit,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductRepository repository;
  
  ProductNotifier({required this.repository}) : super(ProductState()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    if (state.isLoading || state.hasReachedMax) return;
    
    try {
      state = state.copyWith(isLoading: true);
      
      final productModel = await repository.getProducts(
        skip: state.currentSkip,
        limit: state.limit,
      );
      
      final newProducts = productModel.products ?? [];
      final totalProducts = productModel.total ?? 0;
      
      state = state.copyWith(
        products: [...state.products, ...newProducts],
        isLoading: false,
        hasError: false,
        currentSkip: state.currentSkip + state.limit,
        hasReachedMax: state.products.length + newProducts.length >= totalProducts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  void refresh() {
    state = ProductState();
    loadProducts();
  }
}

// Provider that exposes the repository from GetIt
final getProductRepositoryProvider = Provider<GetProductRepository>((ref) {
  return sl<GetProductRepository>();
});

// StateNotifierProvider for pagination
final productNotifierProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final repository = ref.watch(getProductRepositoryProvider);
  return ProductNotifier(repository: repository);
});