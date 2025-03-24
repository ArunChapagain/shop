import 'package:shop/model/product_model.dart';
import 'package:shop/service/get_product_service.dart';

class GetProductRepository {
  final GetProductService getProductService;

  GetProductRepository(this.getProductService);

  Future<ProductModel> getProducts() async {
    try {
      final response = await getProductService.getProducts();
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }
}