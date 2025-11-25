import 'package:flutter/material.dart';

import 'colors_Manager.dart';

class AppStyle{
  //==> Light Theme Starts Here <==//
  static ThemeData lightMode = ThemeData(
    fontFamily: 'helvetica',
    cardTheme: const CardThemeData(surfaceTintColor: Colors.transparent),
    dialogTheme: const DialogThemeData(surfaceTintColor: Colors.transparent),
    useMaterial3: true,
    applyElevationOverlayColor: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorsManager.lightBackground,
    //==> ColorScheme Starts Here <==//
    // colorScheme:ColorScheme.light(
    //     primary: ColorsManager.lightBackground,
    //     primaryContainer: ColorsManager.lightText,
    //     onPrimary: ColorsManager.lightHintText,
    //     onPrimaryContainer: ColorsManager.lightLabelText,
    //     secondary: ColorsManager.lightElements,
    //     onSecondary: ColorsManager.lightFields,
    //     secondaryContainer: ColorsManager.lightBorders,
    //     onSecondaryContainer: ColorsManager.lightMediumBubble,
    //     tertiary: ColorsManager.lightSmallBubble,
    //     tertiaryContainer: ColorsManager.lightLargeBubble ,
    //     onTertiary: ColorsManager.lightModeGradiant,
    // ),
    //==> ColorScheme Ends Here <==//
  );
  //==> Light Theme Ends Here <==//

  //==> Dark Theme Starts Here <==//
  static ThemeData darkMode = ThemeData(
    fontFamily: 'Roboto',
    cardTheme: const CardThemeData(surfaceTintColor: Colors.transparent),
    dialogTheme: const DialogThemeData(surfaceTintColor: Colors.transparent),
    useMaterial3: true,
    applyElevationOverlayColor: false,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorsManager.darkBackground,
    //==> ColorScheme Starts Here <==//
    // colorScheme:ColorScheme.dark(
    //   primary: ColorsManager.darkBackground,
    //   primaryContainer: ColorsManager.darkText,
    //   onPrimary: ColorsManager.darkHintText,
    //   onPrimaryContainer: ColorsManager.darkLabelText ,
    //   secondary: ColorsManager.darkElements,
    //   onSecondary: ColorsManager.darkFields,
    //   secondaryContainer: ColorsManager.darkBorders,
    //   onSecondaryContainer: ColorsManager.darkMediumBubble ,
    //   tertiary: ColorsManager.darkSmallBubble ,
    //   tertiaryContainer: ColorsManager.darkLargeBubble ,
    //   onTertiary: ColorsManager.darkModeGradiant ,
    // ),
    //==> ColorScheme Ends Here <==//
  );
  //==> Dark Theme Ends Here <==//
}