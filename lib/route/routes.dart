
import 'package:flutter/material.dart';
import 'package:practices/route/routesname.dart';
import 'package:practices/views/homepage.dart';
import 'package:practices/views/mybottomnavigationbar.dart';
class Routes{
  static Route<dynamic> generateRoutes(RouteSettings settings){
    switch(settings.name){
      case RoutesName.homePage : return MaterialPageRoute(builder: (context) =>  HomePage(),);
      case RoutesName.bottomnavigationbarpage : return MaterialPageRoute(builder: (context) =>  MyBottomNavigationBar(),);
      default:
        return MaterialPageRoute(builder: (context) => const Scaffold(body: Center(child: Text('No route define'),),),);
    }
  }
}