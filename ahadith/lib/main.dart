import 'package:ahadith/presentation/Screens/home_screen/home_screen.dart';
import 'package:ahadith/theme/theme_constants.dart';
import 'package:ahadith/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'presentation/routes/app_router.dart';

import 'data/data_providers/favorites_and_saved_provider/favorites_and_saved.dart';




void main() async{

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //init hive
  await Hive.initFlutter();

  //open box favorites
  await Hive.openBox('favorites');
  // await Hive.box('favorites').clear(); // remember random short ahadith

  await Hive.openBox('saved');
  // await Hive.box('saved').clear();

  runApp(const MyApp());

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  FlutterNativeSplash.remove();
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManager.addListener(themeListener);
    super.initState();
  }

  themeListener(){
    if(mounted){
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    // var localizationDelegate = LocalizedApp.of(context).delegate;
    return ScreenUtilInit(
        designSize: const Size(411.42857142857144, 914.2857142857143),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => FavoritesAndSavedProvider(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,

              darkTheme: darkTheme(_themeManager),

              themeMode: ThemeMode.dark,

              home: MyHomePage(themeManager: _themeManager),
              onGenerateRoute: AppRouter().generateRoute,
            ),
          );
        });
  }
}
