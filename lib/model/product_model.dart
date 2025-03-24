import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'product.dart';

class ProductModel extends Equatable {
	final List<Product>? products;
	final int? total;
	final int? skip;
	final int? limit;

	const ProductModel({this.products, this.total, this.skip, this.limit});

	factory ProductModel.fromMap(Map<String, dynamic> data) => ProductModel(
				products: (data['products'] as List<dynamic>?)
						?.map((e) => Product.fromMap(e as Map<String, dynamic>))
						.toList(),
				total: data['total'] as int?,
				skip: data['skip'] as int?,
				limit: data['limit'] as int?,
			);

	Map<String, dynamic> toMap() => {
				'products': products?.map((e) => e.toMap()).toList(),
				'total': total,
				'skip': skip,
				'limit': limit,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ProductModel].
	factory ProductModel.fromJson(String data) {
		return ProductModel.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [ProductModel] to a JSON string.
	String toJson() => json.encode(toMap());

	@override
	List<Object?> get props => [products, total, skip, limit];
}
