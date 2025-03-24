import 'package:shop/constant/apis.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shop/model/product_model.dart';

part  'get_product_service.g.dart';

@RestApi(baseUrl:apiURL)

abstract class GetProductService {
  factory GetProductService(Dio dio) = _GetProductService;

  @GET('/products/')
  Future<HttpResponse<List<ProductModel>>> getProducts();
}