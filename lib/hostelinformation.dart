import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practices/components/customtextformfield.dart';
import 'package:practices/modal/hostelmodal.dart';
import 'package:practices/views/addhostel.dart';
import 'package:practices/views/validator/validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class HostelDetailsPage extends StatefulWidget {
  const HostelDetailsPage({Key? key, String? url1}) : super(key: key);

  @override
  State<HostelDetailsPage> createState() => _HostelDetailsPageState();
}

class _HostelDetailsPageState extends State<HostelDetailsPage> {
  final TextEditingController onwerNameController = TextEditingController();
  final TextEditingController cityNameController = TextEditingController();
  final TextEditingController hostalNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController discriptionController = TextEditingController();

  CollectionReference users =
  FirebaseFirestore.instance.collection('hostels');
  final _userRef = FirebaseFirestore.instance.collection('hostels');
  // void _addUserToFirebase(HostelModal user) {
  //   _userRef.add(user.toMap());
  // }
  File? file;
  String? imageUrl;
  Future uploadImage(File file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = file.path;
      Reference storageReference = storage.ref().child('images/$fileName');

      UploadTask uploadTask = storageReference.putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => print('Image uploaded'));
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  int _value = 0;
  bool result = false;
  int wifiValue = 0;
  int waterValue = 0;
  int messValue = 0;
  int parkingValue = 0;
  int bedValue = 0;
  int securityValue = 0;
  List hostelType = ['Boys', 'Girls'];
  List wifiList = ['Yes', 'No'];
  List messList = ['Yes', 'No'];
  List waterList = ['Yes', 'No'];
  List parkingList = ['Yes', 'No'];
  List securityList = ['Yes', 'No'];
  List bedList = ['Yes', 'No'];
  FirebaseAuth _curentUser = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String token = '';
  String? token1;
  Future<String> getToken() async {
    await messaging.requestPermission();
    await messaging.getToken().then((value) {
      if (value != null) {
        setState(() {
          token = value;
          // FirebaseFirestore.instance
          //     .collection('deviceToken')
          //     .add({'token': token.toString()});
        });
        log('Push Token: $token>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.');
      }
    });
    return token;
  }
  @override
  void initState() {
    super.initState();
    getToken();

  }

  // Future<void> sendNotification() async {
  //   var data = {
  //     "to": "cZMufbHzSzu-PpX9oVLIm9:APA91bF4e2PydkYaPZKQiDFq9BRtU2SV_GURMRmEWwg0WRIrJMIRXBD8WxIRQEhCms8lDr9IWvKcdkfOdXul7dQ6iXCBrS0Cr-Hfiuzg5OCHwvk26_qztrUAgtbrmKh03b0nn-e-8C1M",
  //     "notification": {
  //       "title": "Find Hostel",
  //       "body": "One new hostel edded",
  //       "android_channel_id": "Find Hostel"
  //     }
  //   };
  //   await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       body: jsonEncode(data),
  //       headers: {
  //         HttpHeaders.contentTypeHeader: 'application/json',
  //         HttpHeaders.authorizationHeader:
  //         'key = AAAAN1r4zXs:APA91bEjWvwHsuZ_A2nx-gxIOSvrb2ihsFlrh9Z7OHLMxPa7HRdwI0p__urvFdtv__QvAA8BpztpzWenshWGJK7QJhI1C8CFO8wpFxdkxoa574SWgLiOwOSeh7cxEBGAm2HhNzt0e5eY'
  //       });
  // }
  Future addHostel(HostelModal user) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('hostels');
    await users.add({
      'id': user.id,
      'ownername': user.ownerName,
      'ownernumber': user.ownerPhoneNumber,
      'hostelname': user.hostelName,
      'hostelcity': user.hostelCity,
      'hostelDiscription': user.image,
      'type': user.hostelType,
      'wifi': user.wifi,
      'mess': user.mess,
      'witer': user.water,
      'parking': user.parking,
      'bed': user.bed,
      'security': user.security
    });
  }
  final ImagePicker _picker = ImagePicker();
   takePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(image!.path);
    });

  }
  var index1;
  @override
  Widget build(BuildContext context) {
    result;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar(context),
      body:  SingleChildScrollView(
      child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextFormField(
              textCapitalization: TextCapitalization.words,
              controller: onwerNameController,
              validator: (value) {
                return FieldValidator.validateName(value.toString());
              },
              hint: "Owner name ",
              textInputType: TextInputType.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextFormField(

              controller: phoneNumberController,
              validator: (value) {
                return FieldValidator.validatePhoneNumber(value.toString());
              },
              hint: "Owner phoneNumber",
              textInputType: TextInputType.phone, textCapitalization: TextCapitalization.none,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextFormField(
              textCapitalization: TextCapitalization.words,
              controller: hostalNameController,
              validator: (value) {
                return FieldValidator.validateHostelName(value.toString());
              },
              hint: "Hostel name",
              textInputType: TextInputType.name,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextFormField(
              textCapitalization: TextCapitalization.words,
              controller: cityNameController,
              validator: (value) {
                return FieldValidator.validateHostelCity(value.toString());
              },
              hint: "Enter Hostel Complete Address",
              textInputType: TextInputType.name,
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: discriptionController,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Hostel Discription Optional',
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Select Hostel Type",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.teal.shade100,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  for (int i = 0; i <= 1; i++)
                    ListTile(
                      title: Text(hostelType[i],
                          style: const TextStyle(color: Colors.black)),
                      leading: Radio(
                        value: i,
                        groupValue: _value,
                        activeColor: Colors.teal,
                        onChanged: i == 2
                            ? null
                            : (value) {
                          setState(() {
                            _value = value as int;
                            debugPrint(
                                '${_value.toString()}????????');
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Hostel Facilities",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Wifi Available",
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.teal.shade100,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  for (int i = 0; i <= 1; i++)
                    ListTile(
                      title: Text(wifiList[i],
                          style: const TextStyle(color: Colors.black)),
                      leading: Radio(
                        value: i,
                        groupValue: wifiValue,
                        activeColor: Colors.teal,
                        onChanged: i == 2
                            ? null
                            : (value) {
                          setState(() {
                            wifiValue = value as int;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Mess Available",
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.teal.shade100,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  for (int i = 0; i <= 1; i++)
                    ListTile(
                      title: Text(messList[i],
                          style: const TextStyle(color: Colors.black)),
                      leading: Radio(
                        value: i,
                        groupValue: messValue,
                        activeColor: Colors.teal,
                        onChanged: i == 2
                            ? null
                            : (value) {
                          setState(() {
                            messValue = value as int;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Filter Water Available",
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.teal.shade100,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  for (int i = 0; i <= 1; i++)
                    ListTile(
                      title: Text(waterList[i],
                          style: const TextStyle(color: Colors.black)),
                      leading: Radio(
                        value: i,
                        groupValue: waterValue,
                        activeColor: Colors.teal,
                        onChanged: i == 2
                            ? null
                            : (value) {
                          setState(() {
                            waterValue = value as int;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Parking Available",
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.teal.shade100,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  for (int i = 0; i <= 1; i++)
                    ListTile(
                      title: Text(parkingList[i],
                          style: const TextStyle(color: Colors.black)),
                      leading: Radio(
                        value: i,
                        groupValue: parkingValue,
                        activeColor: Colors.teal,
                        onChanged: i == 2
                            ? null
                            : (value) {
                          setState(() {
                            parkingValue = value as int;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Bed System",
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.teal.shade100,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  for (int i = 0; i <= 1; i++)
                    ListTile(
                      title: Text(bedList[i],
                          style: const TextStyle(color: Colors.black)),
                      leading: Radio(
                        value: i,
                        groupValue: bedValue,
                        activeColor: Colors.teal,
                        onChanged: i == 2
                            ? null
                            : (value) {
                          setState(() {
                            bedValue = value as int;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Security System",
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Card(
              color: Colors.teal.shade100,
              elevation: 5,
              child: Column(
                children: <Widget>[
                  for (int i = 0; i <= 1; i++)
                    ListTile(
                      title: Text(securityList[i],
                          style: const TextStyle(color: Colors.black)),
                      leading: Radio(
                        value: i,
                        groupValue: securityValue,
                        activeColor: Colors.teal,
                        onChanged: i == 2
                            ? null
                            : (value) {
                          setState(() {
                            securityValue = value as int;
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          file == null? ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                setState(()  {
                  takePhoto();
                });
                // Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddImage(uid: firebaseAuth.currentUser!.uid,),));
              },
              child: const Text('Add Hostel Images')): Image.file(file!,height: 200,fit: BoxFit.cover,),
          SizedBox(
            height: height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal),
                  onPressed: ()  {
                    if (formKey.currentState!.validate()) {
                      if(file != null){
                        uploadImage(file!).whenComplete((){
                          users.add({
                            'parking': parkingValue == 0 ? 'Yes' : 'No',
                            'security': securityValue == 0 ? 'Yes' : 'No',
                            'mess': messValue == 0 ? 'Yes' : 'No',
                            'wifi': wifiValue == 0 ? 'Yes' : 'No',
                            'hostelType': _value == 0 ? 'Boys' : 'Girls',
                            'hostelCity': cityNameController.text,
                            'bed': bedValue == 0 ? 'Yes' : 'No',
                            'image': imageUrl.toString(),
                            'hostelName': hostalNameController.text,
                            'ownerName': onwerNameController.text,
                            'ownerPhoneNumber': phoneNumberController.text,
                            'water': waterValue == 0 ? 'Yes' : 'No',
                            'id': _curentUser.currentUser!.uid.toString(),
                            'hostelDiscription': discriptionController.text??''
                          }).whenComplete(() async {
                            var data = {
                              "to":
                                  'dryqSMIaTIWHrDReqzlMkr:APA91bHwADbVFlCwQyZRISGs3MbEiqqt9yR_aUW-i7RcjJlF2O921q82nr5kCbc-PTFclGYUVWi5-3WIGEKc-PuOMNV1M4UN8A269MOEqj1hWvSiKTWcrNGXqTs71Fx_WFWlSUMmCGgw'
                            ,
                              "notification": {
                                "title": "One new hostel edded",
                                "body": _curentUser.currentUser!.email.toString(),
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
                          });
                          // HostelModal newUser = HostelModal(
                          //     parking: parkingValue == 0 ? 'Yes' : 'No',
                          //     security: securityValue == 0 ? 'Yes' : 'No',
                          //     mess: messValue == 0 ? 'Yes' : 'No',
                          //     wifi: wifiValue == 0 ? 'Yes' : 'No',
                          //     hostelType: _value == 0 ? 'Boys' : 'Girls',
                          //     hostelCity: cityNameController.text,
                          //     bed: bedValue == 0 ? 'Yes' : 'No',
                          //     image: imageUrl.toString(),
                          //     hostelName: hostalNameController.text,
                          //     ownerName: onwerNameController.text,
                          //     ownerPhoneNumber: phoneNumberController.text,
                          //     water: waterValue == 0 ? 'Yes' : 'No',
                          //     id: _curentUser.currentUser!.uid.toString(), hostelDiscription: discriptionController.text??'');
                          // _addUserToFirebase(newUser);
                        });


                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddHostel(),));

                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Hostel Image is required',
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                          backgroundColor: Colors.teal,
                        ));
                      }
                    }
                  },
                  child: Text('Save')),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          )
        ],
      ),
    ),
    )
    );
  }

  PreferredSize _appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
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
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Add Information',
            style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
