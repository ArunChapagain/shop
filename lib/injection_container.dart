import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shop/repository/get_product_repository.dart';

final sl =GetIt.instance;

Future<void> init() async {
//Dio
  sl.registerSingleton(() => Dio());

//Repository
  sl.registerFactory(() => GetProductRepository(sl()));


}