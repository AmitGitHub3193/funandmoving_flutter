import 'fonts.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: kGrey900);
}

TextTheme _buildTextTheme(TextTheme base) {
  return sTextTheme(base)
      .copyWith(
        headline5: base.headline5!
            .copyWith(fontWeight: FontWeight.w500, color: Colors.red),
        headline6: base.headline6!.copyWith(fontSize: 18.0),
        caption: base.caption!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        subtitle1: base.subtitle1!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
        ),
        button: base.button!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
      )
      .apply(
        displayColor: kGrey900,
        bodyColor: kGrey900,
      )
      .copyWith(headline4: sHeadLineTheme(base).headline4!.copyWith());
}

const ColorScheme kColorScheme = ColorScheme(
  primary: primary,
  primaryVariant: kGrey900,
  secondary: secondary,
  secondaryVariant: kGrey900,
  surface: kSurfaceWhite,
  background: kBackgroundWhite,
  error: kErrorRed,
  onPrimary: kDarkBG,
  onSecondary: kGrey900,
  onSurface: kGrey900,
  onBackground: kGrey900,
  onError: kSurfaceWhite,
  brightness: Brightness.light,
);

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: kColorScheme,
    buttonColor: kTeal400,
    cardColor: Colors.white,
    textSelectionColor: kTeal100,
    errorColor: kErrorRed,
    buttonTheme: const ButtonThemeData(
        colorScheme: kColorScheme,
        textTheme: ButtonTextTheme.normal,
        buttonColor: kDarkBG),
    primaryColorLight: Colors.white,
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
    hintColor: middleColor_light,
    backgroundColor: kLightBG,
    primaryColor: primary,
    accentColor: kLightAccent,
    cursorColor: kLightAccent,
    scaffoldBackgroundColor: kLightBG,
    appBarTheme: const AppBarTheme(
      elevation: 2,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: kDarkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: IconThemeData(
        color: kLightAccent,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black,
      labelPadding: EdgeInsets.zero,
      labelStyle: TextStyle(fontSize: 11),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
  );
}

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme).apply(
      displayColor: kLightBG,
      bodyColor: kLightBG,
    ),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme).apply(
      displayColor: kLightBG,
      bodyColor: kLightBG,
    ),
    accentTextTheme: _buildTextTheme(base.accentTextTheme).apply(
      displayColor: kLightBG,
      bodyColor: kLightBG,
    ),
    cardColor: kDarkBgLight,
    brightness: Brightness.dark,
    backgroundColor: kDarkBG,
    primaryColor: kDarkBG,
    primaryColorLight: kDarkBgLight,
    accentColor: kDarkAccent,
    scaffoldBackgroundColor: kDarkBG,
    cursorColor: kDarkAccent,
    hintColor: middleColor_dark,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: kDarkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: IconThemeData(
        color: kDarkAccent,
      ),
    ),
    buttonTheme: ButtonThemeData(
        colorScheme: kColorScheme.copyWith(onPrimary: kLightBG)),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    }),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      labelPadding: EdgeInsets.zero,
      labelStyle: TextStyle(fontSize: 11),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
  );
}


BoxDecoration playIconDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).primaryColor,
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).primaryColor.withAlpha(200),
        spreadRadius: 1,
        blurRadius: 1,
        offset: Offset(1, 1), // changes position of shadow
      ),
    ],
  );
}

BoxDecoration aboutMeDecoration(BuildContext context) {
  return BoxDecoration(
    color: Color(0xff828ACB),
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).primaryColor.withAlpha(200),
        spreadRadius: 2,
        blurRadius: 3,
        offset: Offset(0, 0), // changes position of shadow
      ),
    ],
  );
}



BoxDecoration buttonDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).primaryColor,
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).accentColor.withAlpha(200),
        spreadRadius: 2,
        blurRadius: 3,
        offset: Offset(0, 0), // changes position of shadow
      ),
    ],
  );
}

BoxDecoration mainActionButtonDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).primaryColor,
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    border: Border.all(color: Colors.black38, width: 1),
  );
}

BoxDecoration playButtonDecoration(BuildContext context) {
  return BoxDecoration(
    color: Colors.black45,
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    boxShadow: [
      BoxShadow(
        color: Colors.grey,
        spreadRadius: 3,
        blurRadius: 8,
        offset: Offset(0, 0), // changes position of shadow
      ),
    ],
  );
}

BoxDecoration itemDecoration(
    BuildContext context, int tappingIndex, int index) {
  var theme = Theme.of(context);
  return BoxDecoration(
    border: Border.all(color: theme.primaryColor, width: 1.6),
    color: tappingIndex == index ? theme.primaryColor : Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: theme.primaryColor.withAlpha(200),
        spreadRadius: 2,
        blurRadius: 3,
        offset: Offset(0, 0),
      ),
    ],
  );
}



