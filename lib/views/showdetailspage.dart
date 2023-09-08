import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
class ShowDetailsPage extends StatelessWidget {
  int index;
  String image;
  String name;
  String number;
  String city;
  String mess;
  String security;
  String wifi;
  String water;
  String parking;
  String nameH;
  String bed;
  String discription;
   ShowDetailsPage({super.key,required this.discription,required this.nameH,required this.wifi,required this.index,required this.image,required this.name,required this.security,required this.bed,required this.parking,required this.water,required this.mess,required this.number,required this.city});

  @override
  Widget build(BuildContext context) {
    print('$index>>>>>>>>>>');
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar(),
      body:
      SafeArea(child: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
                transitionOnUserGestures: true,
                tag: index,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.teal, //<-- SEE HERE
                        ),
                        borderRadius: BorderRadius.circular(10.0),),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(image,height: height*.35 ,width: width,fit: BoxFit.fill,))),
                )),
            const Divider(color: Colors.teal,),
             const Padding(
              padding: EdgeInsets.only(left: 17,top: 2,right: 8,bottom: 0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Hostel Discription',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
                      ))),
            ),
           Padding(
              padding: const EdgeInsets.only(left: 17,top: 8,right: 8,bottom: 8),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(discription,style: const TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
                  )),
            ),
            const Divider(color: Colors.teal,),
            ListTile(title: const Text('Owner Name',style: TextStyle(color: Colors.teal),),trailing: Text(name,style: const TextStyle(color: Colors.teal),),),
            const Divider(color: Colors.teal,),
            ListTile(

              title: const Text('Phone Number',style: TextStyle(color: Colors.teal),),trailing: TextButton.icon(onPressed: () async{

                await FlutterPhoneDirectCaller.callNumber(number);
            }, icon: const Icon(Icons.phone,color: Colors.teal,), label: Text(number,style: const TextStyle(color: Colors.teal),)),),
            const Divider(color: Colors.teal,),

            ListTile(title: const Text('Hostel Name',style: TextStyle(color: Colors.teal),),trailing: Text(nameH,style: const TextStyle(color: Colors.teal),),),
            const Divider(color: Colors.teal,),

            ListTile(title: const Text('Hostel City',style: TextStyle(color: Colors.teal),),trailing: Text(city,style: const TextStyle(color: Colors.teal),),),
            const Divider(color: Colors.teal,),

            ListTile(title: const Text('Mess',style: TextStyle(color: Colors.teal),),trailing: Text(mess,style: const TextStyle(color: Colors.teal),),),
            const Divider(color: Colors.teal,),

            ListTile(title: const Text('Security',style: TextStyle(color: Colors.teal),),trailing: Text(security,style: const TextStyle(color: Colors.teal),),),
            const Divider(color: Colors.teal,),

            ListTile(title: const Text('Filter Water',style: TextStyle(color: Colors.teal),),trailing: Text(water,style: const TextStyle(color: Colors.teal),),),
            const Divider(color: Colors.teal,),

            ListTile(title: const Text('Parking',style: TextStyle(color: Colors.teal),),trailing: Text(parking,style: const TextStyle(color: Colors.teal),),),
            const Divider(color: Colors.teal,),

            ListTile(title: const Text('Bed System',style: TextStyle(color: Colors.teal),),trailing: Text(bed,style: const TextStyle(color: Colors.teal),),),
            const Divider(color: Colors.teal,),

            ListTile(title: const Text('Wifi',style: TextStyle(color: Colors.teal),),trailing: Text(wifi,style: const TextStyle(color: Colors.teal),),),
            const Divider(color: Colors.teal,),

          ],
        ),
      ),),);

  }
  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _boxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              _topBar(name),
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

  Widget _topBar(String name) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.teal.shade800, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
