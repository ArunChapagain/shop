import 'package:shop/model/product_model.dart';
import 'package:shop/service/get_product_service.dart';

class GetProductRepository {
  final GetProductService getProductService;

  GetProductRepository(this.getProductService);

  Future<ProductModel> getProducts({int skip = 0, int limit = 20}) async {
    try {
      final response = await getProductService.getProducts(skip: skip, limit: limit);
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }
}