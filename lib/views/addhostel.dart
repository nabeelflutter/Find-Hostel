import 'package:practices/views/updatepage.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practices/views/homepage.dart';
import '../hostelinformation.dart';
import 'mybottomnavigationbar.dart';
import 'dart:ui';

class AddHostel extends StatefulWidget {
  const AddHostel({super.key});

  @override
  State<AddHostel> createState() => _AddHostelState();
}

class _AddHostelState extends State<AddHostel> {
  final user = FirebaseAuth.instance.currentUser;
  GlobalKey<ScaffoldState> scaffloadKey = GlobalKey<ScaffoldState>();

  Stream<QuerySnapshot> getCurrentUser(BuildContext context) async* {
    yield* FirebaseFirestore.instance
        .collection('hostels')
        .where("id", isEqualTo: user!.uid)
        .snapshots();
  }

  String selectedMenuItem = '';

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Dialog title"),
      content: const Text("Simple Dialog content"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _rotateDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        return Transform.rotate(
          angle: math.radians(a1.value * 360),
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                curve: Curves.bounceInOut,
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                    arrowColor: Colors.white,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.teal.shade300],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    currentAccountPicture: user!.photoURL == null
                        ? CircleAvatar(
                            backgroundColor: Colors.teal.shade100,
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.teal,
                            ),
                          )
                        : CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL.toString()),
                            backgroundColor: Colors.teal.shade100,

                          ),
                    margin: EdgeInsets.zero,
                    accountName: Text(user!.email.toString() ?? ''),
                    accountEmail: const Text('')),
              ),
              ListTile(
                onTap: () {
                  _signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyApp(),
                        ),
                        (route) => false);
                  });
                },
                title: Text('LogOut'),
                trailing: Icon(Icons.logout),
              )
            ],
          ),
        ),
        key: scaffloadKey,
        // appBar: _appBar(context),
        appBar: _appBar(context),
        //  appBar: AppBar(
        //    actions: [
        //      PopupMenuButton(itemBuilder: (context) => [
        //        PopupMenuItem<String>(
        //          value: 'Update',
        //          enabled: true,
        //          textStyle: TextStyle(color: Colors.teal),
        //          child: Icon(Icons.edit,color: Colors.teal,),
        //        ),
        //        PopupMenuItem<String>(
        //          child: Icon(Icons.delete,color: Colors.teal,),
        //        )
        //      ],)
        //    ],
        //  ),
        body: StreamBuilder(
          stream: getCurrentUser(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.teal,),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Some thing went wrong',
                  style: TextStyle(color: Colors.teal),
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  snapshot.data!.docs[index]
                                      .get('image')
                                      .toString(),
                                  height: height * .40,
                                  width: width,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: new ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.grey.shade200
                                            .withOpacity(0.5)),
                                    child: PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem<String>(
                                          onTap: () {
                                            Future.delayed(
                                                Duration(seconds: 0),
                                                () => Navigator.push(context,
                                                        MaterialPageRoute(
                                                      builder: (context) {
                                                        return UpdatePage(
                                                          index: snapshot.data!
                                                              .docs[index].id,
                                                        );
                                                      },
                                                    )));
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          onTap: () {
                                            Future.delayed(
                                                const Duration(seconds: 0),
                                                () => showGeneralDialog(
                                                      context: context,
                                                      pageBuilder:
                                                          (ctx, a1, a2) {
                                                        return Container();
                                                      },
                                                      transitionBuilder:
                                                          (ctx, a1, a2, child) {
                                                        return Transform.rotate(
                                                          angle: math.radians(
                                                              a1.value * 360),
                                                          child: AlertDialog(
                                                            title: const Text(
                                                                "Delete Hostel"),
                                                            content: const Text(
                                                                "Are you sure you want to delete?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child: const Text(
                                                                      "Cancle")),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'hostels')
                                                                        .doc(snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .id)
                                                                        .delete();
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "Yes")),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      transitionDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  300),
                                                    ));
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (ctx) => AlertDialog(
                                            //     title: const Text("Alert Dialog Box"),
                                            //     content: const Text("You have raised a Alert Dialog Box"),
                                            //     actions: <Widget>[
                                            //       TextButton(
                                            //         onPressed: () {
                                            //           FirebaseFirestore.instance.collection('hostels').doc(snapshot.data!.docs[index].id).delete();
                                            //
                                            //         },
                                            //         child: Container(
                                            //           color: Colors.green,
                                            //           padding: const EdgeInsets.all(14),
                                            //           child: const Text("okay"),
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // );
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.teal,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: height * .05,
                              left: width * .05,
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: new ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.grey.shade200
                                            .withOpacity(0.5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Address :',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]
                                                .get('hostelCity')
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: height * .05,
                              right: width * .05,
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: new ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                        color: Colors.grey.shade200
                                            .withOpacity(0.5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Type: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            snapshot.data!.docs[index]
                                                .get('hostelType')
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * .001,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _boxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              _topBar(context),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(20),
      ),
      gradient: LinearGradient(
        colors: [Colors.white, Colors.teal.shade300],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: () {
              scaffloadKey.currentState!.openDrawer();
            },
            child: Icon(
              Icons.menu,
              color: Colors.teal,
            )),
        IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                  (route) => false);
            },
            icon: const Icon(
              Icons.home,
              color: Colors.teal,
              size: 25,
            )),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HostelDetailsPage(),
                  ));
            },
            icon: const Icon(Icons.add),
            label: const Text('AddHostel')),
      ],
    );
  }
}
// import 'package:practices/views/updatepage.dart';
// import 'package:vector_math/vector_math.dart' as math;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:practices/views/homepage.dart';
// import '../hostelinformation.dart';
// import 'mybottomnavigationbar.dart';
//
// class AddHostel extends StatefulWidget {
//   const AddHostel({super.key});
//
//   @override
//   State<AddHostel> createState() => _AddHostelState();
// }
//
// class _AddHostelState extends State<AddHostel> {
//   final user = FirebaseAuth.instance.currentUser;
//   GlobalKey<ScaffoldState> scaffloadKey = GlobalKey<ScaffoldState>();
//   Stream<QuerySnapshot> getCurrentUser(BuildContext context) async* {
//     yield* FirebaseFirestore.instance
//         .collection('hostels')
//         .where("id", isEqualTo: user!.uid)
//         .snapshots();
//   }
//
//   String selectedMenuItem = '';
//
//   Widget _dialog(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Dialog title"),
//       content: const Text("Simple Dialog content"),
//       actions: <Widget>[
//         TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text("Okay"))
//       ],
//     );
//   }
//
//   void _rotateDialog() {
//     showGeneralDialog(
//       context: context,
//       pageBuilder: (ctx, a1, a2) {
//         return Container();
//       },
//       transitionBuilder: (ctx, a1, a2, child) {
//         return Transform.rotate(
//           angle: math.radians(a1.value * 360),
//           child: _dialog(ctx),
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 300),
//     );
//   }
//   Future<void> _signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//         drawer:  Drawer(
//           child:  Column(children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
//               curve: Curves.bounceInOut,
//               padding: EdgeInsets.zero,
//               child: UserAccountsDrawerHeader(
//                   arrowColor: Colors.white,
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Colors.white, Colors.teal.shade300],
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                       ),
//                       borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
//                   ),
//                   currentAccountPicture:  CircleAvatar(
//                     backgroundColor: Colors.teal.shade100,
//                     child: Icon(Icons.person,size: 30,color: Colors.teal,),
//                   ),
//                   margin: EdgeInsets.zero,
//                   accountName:  Text(user!.email.toString()??''),
//                   accountEmail: const Text('')),
//             ),
//             ListTile(
//               onTap: (){
//                 _signOut().then((value) {
//                   Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => MyApp(),), (route) => false);
//                 });
//               },
//               title: Text('LogOut'),trailing: Icon(Icons.logout),)
//           ],),
//         ),
//         key: scaffloadKey,
//         // appBar: _appBar(context),
//         appBar: _appBar(context),
//         //  appBar: AppBar(
//         //    actions: [
//         //      PopupMenuButton(itemBuilder: (context) => [
//         //        PopupMenuItem<String>(
//         //          value: 'Update',
//         //          enabled: true,
//         //          textStyle: TextStyle(color: Colors.teal),
//         //          child: Icon(Icons.edit,color: Colors.teal,),
//         //        ),
//         //        PopupMenuItem<String>(
//         //          child: Icon(Icons.delete,color: Colors.teal,),
//         //        )
//         //      ],)
//         //    ],
//         //  ),
//         body: StreamBuilder(
//           stream: getCurrentUser(context),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return const Center(
//                 child: Text(
//                   'Some thing went wrong',
//                   style: TextStyle(color: Colors.teal),
//                 ),
//               );
//             }
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: InkWell(
//                     onTap: () {},
//                     child: Card(
//                       elevation: 2,
//                       shape: RoundedRectangleBorder(
//                         side: const BorderSide(
//                           color: Colors.teal, //<-- SEE HERE
//                         ),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: SizedBox(
//                         height: height * .35,
//                         width: width,
//                         // decoration: BoxDecoration(border: Border.all(color: Colors.teal)),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.network(
//                                     snapshot.data!.docs[index]
//                                         .get('image')
//                                         .toString(),
//                                     height: height * .25,
//                                     width: width,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   right: .2,
//                                   child: PopupMenuButton(
//                                     itemBuilder: (context) => [
//                                       PopupMenuItem<String>(
//                                         onTap: () {
//                                           Future.delayed(Duration(seconds: 0),() => Navigator.push(context, MaterialPageRoute(builder: (context) {
//                                             return UpdatePage(
//                                               index: snapshot.data!.docs[index].id,
//                                             );
//                                           },)) );
//
//                                         },
//                                         child: const Icon(
//                                           Icons.edit,
//                                           color: Colors.teal,
//                                         ),
//                                       ),
//                                       PopupMenuItem<String>(
//                                         onTap: () {
//                                           Future.delayed(
//                                               const Duration(seconds: 0),
//                                                   () => showGeneralDialog(
//                                                 context: context,
//                                                 pageBuilder: (ctx, a1, a2) {
//                                                   return Container();
//                                                 },
//                                                 transitionBuilder:
//                                                     (ctx, a1, a2, child) {
//                                                   return Transform.rotate(
//                                                     angle: math.radians(
//                                                         a1.value * 360),
//                                                     child: AlertDialog(
//                                                       title: const Text(
//                                                           "Delete Hostel"),
//                                                       content: const Text(
//                                                           "Are you sure you want to delete?"),
//                                                       actions: <Widget>[
//
//                                                         TextButton(
//                                                             onPressed: () {
//                                                               Navigator.of(
//                                                                   context)
//                                                                   .pop();
//                                                             },
//                                                             child: const Text(
//                                                                 "Cancle")),
//                                                         TextButton(
//                                                             onPressed: () {
//                                                               FirebaseFirestore
//                                                                   .instance
//                                                                   .collection(
//                                                                   'hostels')
//                                                                   .doc(snapshot
//                                                                   .data!
//                                                                   .docs[
//                                                               index]
//                                                                   .id)
//                                                                   .delete();
//                                                               Navigator.of(
//                                                                   context)
//                                                                   .pop();
//                                                             },
//                                                             child: const Text(
//                                                                 "Yes")),
//                                                       ],
//                                                     ),
//                                                   );
//                                                 },
//                                                 transitionDuration:
//                                                 const Duration(
//                                                     milliseconds: 300),
//                                               ));
//                                           // showDialog(
//                                           //   context: context,
//                                           //   builder: (ctx) => AlertDialog(
//                                           //     title: const Text("Alert Dialog Box"),
//                                           //     content: const Text("You have raised a Alert Dialog Box"),
//                                           //     actions: <Widget>[
//                                           //       TextButton(
//                                           //         onPressed: () {
//                                           //           FirebaseFirestore.instance.collection('hostels').doc(snapshot.data!.docs[index].id).delete();
//                                           //
//                                           //         },
//                                           //         child: Container(
//                                           //           color: Colors.green,
//                                           //           padding: const EdgeInsets.all(14),
//                                           //           child: const Text("okay"),
//                                           //         ),
//                                           //       ),
//                                           //     ],
//                                           //   ),
//                                           // );
//                                         },
//                                         child: const Icon(
//                                           Icons.delete,
//                                           color: Colors.teal,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 )
//                                 // Positioned(
//                                 //     right: .2,
//                                 //     top: .2,
//                                 //     child: Icon(Icons.more_vert_outlined)),
//                               ],
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Divider(color: Colors.teal,),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       const Text(
//                                         'Address :',
//                                         style: TextStyle(color: Colors.teal),
//                                       ),
//                                       Text(
//                                         snapshot.data!.docs[index]
//                                             .get('hostelCity')
//                                             .toString(),
//                                         style: const TextStyle(
//                                             color: Colors.teal,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                   Row(
//                                     children: [
//                                       const Text(
//                                         'Type: ',
//                                         style: TextStyle(
//                                             color: Colors.teal,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                         snapshot.data!.docs[index]
//                                             .get('hostelType')
//                                             .toString(),
//                                         style:
//                                         const TextStyle(color: Colors.teal),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: height * .001,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ));
//   }
//
//   PreferredSize _appBar(BuildContext context) {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(70),
//       child: Container(
//         margin: const EdgeInsets.only(top: 5),
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         decoration: _boxDecoration(),
//         child: SafeArea(
//           child: Column(
//             children: [
//               _topBar(context),
//               const SizedBox(height: 5),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   BoxDecoration _boxDecoration() {
//     return BoxDecoration(
//       borderRadius: const BorderRadius.vertical(
//         bottom: Radius.circular(20),
//       ),
//       gradient: LinearGradient(
//         colors: [Colors.white, Colors.teal.shade300],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       ),
//     );
//   }
//
//   Widget _topBar(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         InkWell(
//             onTap: () {
//               scaffloadKey.currentState!.openDrawer();
//             },
//             child:  Icon(Icons.menu,color: Colors.teal,)),
//         IconButton(
//             onPressed: () {
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const MyApp(),
//                   ),
//                       (route) => false);
//             },
//             icon: const Icon(
//               Icons.home,
//               color: Colors.teal,
//               size: 30,
//             )),
//         ElevatedButton.icon(
//             style:
//             ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade900),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const HostelDetailsPage(),
//                   ));
//             },
//             icon: const Icon(Icons.add),
//             label: const Text('AddHostel')),
//       ],
//     );
//   }
// }
