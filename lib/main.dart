import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled1/db/db_helper.dart';
import 'package:untitled1/services/themes_servecies.dart';
import 'package:untitled1/ui/home_page.dart';
import 'package:untitled1/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBhelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.ligth,
      darkTheme: Themes.dark,
      themeMode: ThemeServecies().theme,
      home: const HomePge(),
    );
  }
}
