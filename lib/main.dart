import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shop/core/theme/app_theme.dart';
import 'package:shop/injection_container.dart';
import 'package:shop/pages/product_list/product_list.dart';
import 'package:shop/core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'Shop App',
      theme: AppTheme.lightTheme(),
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
