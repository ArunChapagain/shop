import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shop/repository/get_product_repository.dart';
import 'package:shop/service/get_product_service.dart';

final sl =GetIt.instance;
Future<void> init() async {
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
}