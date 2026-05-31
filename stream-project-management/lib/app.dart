import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/dashboard_screen.dart';

/// App 根组件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'AI OPC',
        // 深色模式主题（设计文档 5.5.2）
        theme: FlexThemeData.light(
          scheme: FlexScheme.indigoM3,
          appBarElevation: 0,
          subThemesData: const FlexSubThemesData(
            defaultRadius: 12,
            inputDecoratorRadius: 12,
            cardRadius: 16,
          ),
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.indigoM3,
          appBarElevation: 0,
          subThemesData: const FlexSubThemesData(
            defaultRadius: 12,
            inputDecoratorRadius: 12,
            cardRadius: 16,
          ),
        ),
        themeMode: ThemeMode.dark, // 默认深色模式（设计文档 5.5.2）
        debugShowCheckedModeBanner: false,
        home: const DashboardScreen(),
      ),
    );
  }
}
