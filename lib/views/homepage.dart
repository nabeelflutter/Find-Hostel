import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:practices/views/showdetailspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String token = '';

  Future<String> getToken() async {
    await messaging.requestPermission();
    await messaging.getToken().then((value) {
      if (value != null) {
        setState(() {
          token = value;
          FirebaseFirestore.instance
              .collection('deviceToken')
              .add({'token': token.toString()});
        });
        log('Push Token: $token>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
      }
    });
    return token;
  }

  String name = "";
  final TextEditingController _searchText = TextEditingController();
  GlobalKey<ScaffoldState> scaffloadKey = GlobalKey<ScaffoldState>();

  Stream<QuerySnapshot> getAllUser(
      BuildContext context,) async* {
    yield* FirebaseFirestore.instance
        .collection('hostels').where('hostelname',arrayContains: _searchText.text).snapshots();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   getAllUser(context);
  // }
  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future<void> sendNotification() async {
    var data = {
      "to": "cZMufbHzSzu-PpX9oVLIm9:APA91bF4e2PydkYaPZKQiDFq9BRtU2SV_GURMRmEWwg0WRIrJMIRXBD8WxIRQEhCms8lDr9IWvKcdkfOdXul7dQ6iXCBrS0Cr-Hfiuzg5OCHwvk26_qztrUAgtbrmKh03b0nn-e-8C1M",
      "notification": {
        "title": "Find Hostel",
        "body": "One new hostel edded",
        "android_channel_id": "Find Hostel"
      }
    };
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key = AAAAN1r4zXs:APA91bEjWvwHsuZ_A2nx-gxIOSvrb2ihsFlrh9Z7OHLMxPa7HRdwI0p__urvFdtv__QvAA8BpztpzWenshWGJK7QJhI1C8CFO8wpFxdkxoa574SWgLiOwOSeh7cxEBGAm2HhNzt0e5eY'
        });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: _appBar(),
        body: StreamBuilder(
          stream: (name != "" && name != null)
              ? FirebaseFirestore.instance
                  .collection('hostels')
                  .where("hostelCity", isEqualTo: name)
                  .snapshots()
              : FirebaseFirestore.instance.collection("hostels").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowDetailsPage(
                                  index: index,
                                  image: snapshot.data!.docs[index]
                                      .get('image')
                                      .toString(),
                                  name: snapshot.data!.docs[index]
                                      .get('ownerName')
                                      .toString(),
                                  security: snapshot.data!.docs[index]
                                      .get('security')
                                      .toString(),
                                  bed: snapshot.data!.docs[index]
                                      .get('bed')
                                      .toString(),
                                  parking: snapshot.data!.docs[index]
                                      .get('parking')
                                      .toString(),
                                  water: snapshot.data!.docs[index]
                                      .get('water')
                                      .toString(),
                                  mess: snapshot.data!.docs[index]
                                      .get('mess')
                                      .toString(),
                                  number: snapshot.data!.docs[index]
                                      .get('ownerPhoneNumber')
                                      .toString(),
                                  city: snapshot.data!.docs[index]
                                      .get('hostelCity')
                                      .toString(),
                                  wifi: snapshot.data!.docs[index]
                                      .get('wifi')
                                      .toString(),
                                  nameH: snapshot.data!.docs[index]
                                      .get('hostelName')
                                      .toString(),
                                  discription: snapshot.data!.docs[index]
                                      .get('hostelDiscription')
                                      .toString()),
                            ));
                      },
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag: snapshot.data!.docs[index],
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
                                  bottom: height*.05,
                                  left: width*.05,
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.grey.shade200.withOpacity(0.5)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              const Text(
                                                'Address :',
                                                style:
                                                TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
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
                                  bottom: height*.05,
                                  right: width*.05,

                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.grey.shade200.withOpacity(0.5)
                                        ),
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
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Some thing went wrong',
                  style: TextStyle(color: Colors.teal),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _boxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              _topBar(),
              const SizedBox(height: 5),
              _searchBox(),
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

  Widget _topBar() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'FindHostel',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return SizedBox(
      height: 45,
      child: TextFormField(
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        onChanged: (val) {
          setState(() {
            name = val;
          });
        },
        textAlign: TextAlign.start,
        controller: _searchText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: InkWell(
              onTap: () {
                scaffloadKey.currentState!.openDrawer();
              },
              child: const Icon(
                Icons.location_city_rounded,
                color: Colors.teal,
              )),
          suffixIcon: InkWell(
            child: const Icon(
              Icons.close,
              color: Colors.teal,
            ),
            onTap: () {
              _searchText.clear();
              setState(() {
                name = "";
              });
            },
          ),
          hintText: 'Search City...',
          contentPadding: const EdgeInsets.all(0),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        cursorColor: Colors.teal,
      ),
    );
  }
}
