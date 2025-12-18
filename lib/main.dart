import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oasisathletic/ui/home_screen/sideMenu/Gallery/galleryAlbums.dart';
import 'package:oasisathletic/ui/home_screen/sideMenu/Gallery/widget/cart_screen.dart';
import 'package:oasisathletic/ui/home_screen/sideMenu/Gallery/widget/provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_style.dart';

import 'ui/drawer/about_us.dart';
import 'ui/drawer/appointments.dart';
import 'ui/drawer/bus_registeration.dart';
import 'ui/drawer/canteen_charge.dart';
import 'ui/drawer/messages.dart';
import 'ui/drawer/payment_Information.dart';
import 'ui/drawer/policies.dart';
import 'ui/drawer/settings.dart';

import 'ui/home_screen/Home/home_screen.dart';
import 'ui/home_screen/MSGScreens/sendMessagesScreen.dart';
import 'ui/home_screen/sideMenu/newsLetter/NewsLetterScreen.dart';
import 'ui/home_screen/widgets/student_inside.dart';

import 'ui/login_screen/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize easy_localization
  await EasyLocalization.ensureInitialized();

  // get shared preferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Get token safely
  final String token = prefs.getString('token') ?? '';

  // Decide start route
  final String startRoute =
  token.isEmpty ? LoginScreen.routeName : HomeScreen.routeName;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MyApp(initialRoute: startRoute),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({
    super.key,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Oasis Parents',
          debugShowCheckedModeBanner: false,

          themeMode: ThemeMode.light,
          theme: AppStyle.lightMode,
          darkTheme: AppStyle.darkMode,

          initialRoute: initialRoute,
          routes: {
            HomeScreen.routeName: (_) => HomeScreen(),
            LoginScreen.routeName: (_) => LoginScreen(),
            Settings.routeName: (_) => Settings(),
            AboutUs.routeName: (_) => AboutUs(),
            Policies.routeName: (_) => Policies(),
            BusRegisteration.routeName: (_) => BusRegisteration(),
            GalleryAlbums.routeName: (_) => GalleryAlbums(),
            Appointments.routeName: (_) => Appointments(),
            CanteenCharge.routeName: (_) => CanteenCharge(),
            PaymentInformation.routeName: (_) => PaymentInformation(),
            NewsLetterScreen.routeName: (_) => NewsLetterScreen(),
            sendMessagesScreen.routeName: (_) => const sendMessagesScreen(),
            MessagesScreen.routeName: (_) => MessagesScreen(),
            StudentInside.routeName: (_) => StudentInside(),
            CartScreen.routeName: (_) => const CartScreen(),
          },

          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}