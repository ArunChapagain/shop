import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shop/model/cart_item.dart';
import 'package:shop/repository/cart_repository.dart';
import 'package:shop/repository/get_product_repository.dart';
import 'package:shop/service/get_product_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

final sl =GetIt.instance;
Future<void> init() async {
  
  // Hive - must be initialized before any Hive operation
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemModelAdapter());

  // Dio
  sl.registerSingleton(Dio());
  
  // Service - must be registered before repository
  sl.registerFactory<GetProductService>(
    () => GetProductService(sl<Dio>())
  );
  
  // Repository - now explicitly getting the service
  sl.registerFactory<GetProductRepository>(
    () => GetProductRepository(sl<GetProductService>())
  );

 sl.registerLazySingleton<CartRepository>(() => CartRepository());
}