import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkPrimary = HexColor('#222831');
  static final darkSecondary = HexColor('#393E46');

  static final darkStylePrimary = HexColor('#4c4c4c');

  static final lightPrimary = HexColor('#EEEEEE');
  static final lightSecondary = HexColor('#F7FBFC');

  static final lightStylePrimary1 = HexColor('#F73859');

  static final foodThemeColor = HexColor('#FFD460');
  Color get foodColor {
    return foodThemeColor;
  }

  static final spotThemeColor = HexColor('#00B8A9');
  Color get spotColor {
    return spotThemeColor;
  }

  static final accomodationThemeColor = HexColor('#3282B8');
  Color get accomodationColor {
    return accomodationThemeColor;
  }

  static final activityThemeColor = HexColor('#F6416C');
  Color get activityColor {
    return activityThemeColor;
  }

  static final darkTheme = ThemeData(
    fontFamily: 'Poppins',
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkPrimary,
    drawerTheme: DrawerThemeData(
      backgroundColor: darkPrimary,
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: darkPrimary,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: 20,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: darkPrimary,
      indicatorColor: Colors.transparent,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      iconTheme: MaterialStateProperty.all(
        IconThemeData(
          color: lightPrimary.withOpacity(.7),
          size: 26,
        ),
      ),
    ),
    cardColor: darkSecondary,
    cardTheme: CardTheme(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  static final lightTheme = ThemeData(
    fontFamily: 'Poppins',
    primaryColor: Colors.white,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightPrimary,
    drawerTheme: DrawerThemeData(
      backgroundColor: lightPrimary,
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: lightPrimary,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w900,
        fontSize: 20,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightPrimary,
      indicatorColor: Colors.transparent,
      labelTextStyle: MaterialStateProperty.all(
        TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: lightStylePrimary1,
        ),
      ),
      iconTheme: MaterialStateProperty.all(
        IconThemeData(
          color: darkPrimary.withOpacity(.7),
          size: 26,
        ),
      ),
    ),
    cardColor: lightSecondary,
    cardTheme: CardTheme(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  Color getPrimaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isDarkMode) {
      return darkPrimary;
    } else {
      return lightPrimary;
    }
  }

  Color getSecondaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isDarkMode) {
      return darkSecondary;
    } else {
      return lightSecondary;
    }
  }

  Color getStylePrimaryColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isDarkMode) {
      return darkStylePrimary;
    } else {
      return lightStylePrimary1;
    }
  }

  Color getDarkLight(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isDarkMode) {
      return Colors.white;
    } else {
      return Colors.blueAccent;
    }
  }

  Color getFontAllWhite(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isDarkMode) {
      return Colors.white;
    } else {
      return Colors.white;
    }
  }

  Color getIconColor(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isDarkMode) {
      return Colors.white;
    } else {
      return HexColor('#F73859');
    }
  }

  Color getFontwithOpacity(BuildContext context, double value) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isDarkMode) {
      return Colors.white.withOpacity(value);
    } else {
      return Colors.black.withOpacity(value);
    }
  }

  Color getIconColorDark(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isDarkMode) {
      return darkPrimary;
    } else {
      return HexColor('#F73859');
    }
  }
}
