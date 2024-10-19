import 'package:ev_charge/screens/home_screen.dart';
import 'package:ev_charge/screens/station_details_screen.dart';
import 'package:ev_charge/screens/verification/login_page.dart';
import 'package:ev_charge/widgets/khalti_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routesettings) {
  switch (routesettings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const HomeScreen(),
      );
    case LoginPage.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const LoginPage(),
      );
    case StationDetailsScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const StationDetailsScreen(),
      );
    case KhaltiScreen.routeName:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const KhaltiScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routesettings,
        builder: (_) => const Scaffold(
          body: Text('Page not found'),
        ),
      );
  }
}
