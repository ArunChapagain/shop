
import 'dart:developer';

import 'package:shop/core/constant/apis.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shop/model/product_list.dart';

part 'get_product_service.g.dart';

@RestApi(baseUrl: apiURL)
abstract class GetProductService {
  factory GetProductService(Dio dio) = _GetProductService;

  @GET('/products/')
  Future<HttpResponse<ProductListModel>> getProducts({
    @Query('skip') int skip = 0,
    @Query('limit') int limit = 20,
  });
}
