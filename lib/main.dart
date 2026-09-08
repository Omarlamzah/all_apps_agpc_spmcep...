import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'src/app.dart';
import 'src/config/app_brand.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await LiquidGlassWidgets.initialize(enablePerformanceMonitor: false);
  runApp(
    LiquidGlassWidgets.wrap(
      adaptiveQuality: true,
      brightnessResolver: Theme.maybeBrightnessOf,
      child: CongressApp(brand: AppBrand.fromEnvironment()),
    ),
  );
}
