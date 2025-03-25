import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shop/model/product.dart';
import 'package:shop/pages/product_cart/cart.dart';
import 'package:shop/pages/product_details/product_details.dart';
import 'package:shop/pages/product_list/product_list.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: ProductListRoute.page, initial: true),
    AutoRoute(page: ProductDetailsRoute.page),
    AutoRoute(page: CartRoute.page),
  ];
}
