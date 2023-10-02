import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practices/provider/bottomnavigationbarwithprovider.dart';
import 'package:practices/provider/loadingprovider.dart';
import 'package:practices/views/signinpage.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'addhostel.dart';
import 'homepage.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( providers: [
      ChangeNotifierProvider(create: (context) => LoadingProvider(),),
      ChangeNotifierProvider(create: (context) => BottomNavigationBarProvider(),),
    ],
    child: MyBottomNavigationBar(),
    );
  }
}
class MyBottomNavigationBar extends StatelessWidget {
  var currentBackPressTime;
  List<dynamic> screens = [
     HomePage(),
    LoginScreen()
  ];
   MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final _screenindexprovider = Provider.of<BottomNavigationBarProvider>(context);

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(

        body: screens[_screenindexprovider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal.shade100,
      //  type: BottomNavigationBarType.shifting,
        currentIndex: _screenindexprovider.currentIndex,
        elevation: 1.5,
        selectedItemColor: Colors.teal.shade900,
        unselectedItemColor: Colors.teal,
        onTap: (index){
          if(index==1){
            final auth = FirebaseAuth.instance;
            final user = auth.currentUser;
            if (user != null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddHostel(),));
            }
          }
          _screenindexprovider.setCurrentIndex(index);
        },
        items: const [

         BottomNavigationBarItem(icon: Icon(Icons.home,),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add,),label: 'Add'),


      ],),
      ),
    );
  }
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press again to exit the app!',backgroundColor: Colors.teal);

      return Future.value(false);
    }
    return Future.value(true);
  }
}

