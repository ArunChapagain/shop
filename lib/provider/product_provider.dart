import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/model/product_model.dart';
import 'package:shop/repository/get_product_repository.dart';
import 'package:shop/injection_container.dart';

// Provider that exposes the repository from GetIt
final getProductRepositoryProvider = Provider<GetProductRepository>((ref) {
  return sl<GetProductRepository>();
});

// Provider to get products using the repository
final productsProvider = FutureProvider<ProductModel>((ref) async {
  final repository = ref.watch(getProductRepositoryProvider);
  return repository.getProducts();
});