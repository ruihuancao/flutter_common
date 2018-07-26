import 'package:flutter/material.dart';

// 应用主题类
class AppTheme {
  const AppTheme._(this.name, this.data);

  final String name;
  final ThemeData data;

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType)
      return false;
    final AppTheme typedOther = other;
    return name == typedOther.name
        && data == typedOther.data;
  }

  @override
  int get hashCode => hashValues(
    name,
    data,
  );

}

final AppTheme kDarkTheme = new AppTheme._('Dark', _buildDarkTheme());
final AppTheme kLightTheme = new AppTheme._('Light', _buildLightTheme());


TextTheme _buildTextTheme(TextTheme base) {
  return base.copyWith(
    title: base.title.copyWith(
      //fontFamily: 'GoogleSans',
    ),
  );
}

AppTheme getThemeByName(String name){
  if(name == "Dark"){
    return kDarkTheme;
  }else{
    return kLightTheme;
  }
}

ThemeData _buildDarkTheme() {
  const Color primaryColor = const Color(0xFF0175c2);
  final ThemeData base = new ThemeData.dark();
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    accentColor: const Color(0xFF13B9FD),
    canvasColor: const Color(0xFF202124),
    scaffoldBackgroundColor: const Color(0xFF202124),
    backgroundColor: const Color(0xFF202124),
    errorColor: const Color(0xFFB00020),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    cardColor: Colors.black12,
  );
}

ThemeData _buildLightTheme() {
  const Color primaryColor = const Color(0xFF0175c2);
  final ThemeData base = new ThemeData.light();
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    accentColor: const Color(0xFF13B9FD),
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white70,
    backgroundColor: Colors.white70,
    errorColor: const Color(0xFFB00020),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    iconTheme: const IconThemeData(),
    cardColor: Colors.white,
  );
}