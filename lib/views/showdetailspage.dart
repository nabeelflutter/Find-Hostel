import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:carousel_slider/carousel_slider.dart';
class ShowDetailsPage extends StatefulWidget {
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
  State<ShowDetailsPage> createState() => _ShowDetailsPageState();
}

class _ShowDetailsPageState extends State<ShowDetailsPage> {
  int _current = 0;

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    print('${widget.index}>>>>>>>>>>');
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
                tag: widget.index,
                child: Padding(
                  padding:  EdgeInsets.all(8.0),
                child: CarouselSlider(
                items: [
                  Image.network(widget.image,height: height*.45 ,width: width,fit: BoxFit.fill,)
                ],
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),

        ),

                  // child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: Image.network(image,height: height*.35 ,width: width,fit: BoxFit.fill,)),
                )),

              Padding(
              padding: EdgeInsets.only(left: 17,top: height*.05,right: 8,bottom: 0),
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
              padding:  EdgeInsets.only(left: 17,top: height*.01,right: 8,bottom: 8),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.discription,style: const TextStyle(color: Colors.black),),
                  )),
            ),

            Card(
                color: Colors.teal,
                elevation: 2,
                child: ListTile(title: const Text('Owner Name',style: TextStyle(color: Colors.white),),trailing: Text(widget.name,style: const TextStyle(color: Colors.white),),)),
            Card(
              color: Colors.teal,
              elevation: 2,
              child: ListTile(

                title: const Text('Phone Number',style: TextStyle(color: Colors.white),),trailing: TextButton.icon(onPressed: () async{

                  await FlutterPhoneDirectCaller.callNumber(widget.number);
              }, icon:  Icon(Icons.phone,color: Colors.green.shade300,), label: Text(widget.number,style: const TextStyle(color: Colors.white),)),),
            ),

            Card(
                color: Colors.teal,
                elevation: 2,
                child: ListTile(title: const Text('Hostel Name',style: TextStyle(color: Colors.white),),trailing: Text(widget.nameH,style: const TextStyle(color: Colors.white),),)),

            Card(
                color: Colors.teal,
                elevation: 2,
                child: ListTile(title: const Text('Hostel Address',style: TextStyle(color: Colors.white),),trailing: Text(widget.city,style: const TextStyle(color: Colors.white),),)),

            Card(
                color: Colors.teal,
                elevation: 2,
                child: ListTile(title: const Text('Mess',style: TextStyle(color: Colors.white),),trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(child: widget.mess == 'Yes'?Text('✔',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),):Text('X',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),),
                    height: 80,width: 40,decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    color: widget.mess == 'Yes'?Colors.green:Colors.red
                  ),),
                ),)),

            Card(
                color: Colors.teal,
                elevation: 2,
                child: ListTile(title: const Text('Security',style: TextStyle(color: Colors.white),),trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(child: widget.security == 'Yes'?Text('✔',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),):Text('X',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),),
                    height: 80,width: 40,decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      color: widget.security == 'Yes'?Colors.green:Colors.red
                  ),),
                ),)),

            Card(
                color: Colors.teal,
                elevation: 2,
                child: ListTile(title: const Text('Filter Water',style: TextStyle(color: Colors.white),),trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(child: widget.water == 'Yes'?Text('✔',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),):Text('X',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),),
                    height: 80,width: 40,decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      color: widget.water == 'Yes'?Colors.green:Colors.red
                  ),),
                ),)),

            Card(
                color: Colors.teal,
                elevation: 2,
                child: ListTile(title: const Text('Parking',style: TextStyle(color: Colors.white),),trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(child: widget.parking == 'Yes'?Text('✔',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),):Text('X',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),),
                    height: 80,width: 40,decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      color: widget.parking == 'Yes'?Colors.green:Colors.red
                  ),),
                ),)),

            Card(
                color: Colors.teal,
                elevation: 2,
                child: ListTile(title: const Text('Bed System',style: TextStyle(color: Colors.white),),trailing:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(child: widget.bed == 'Yes'?Text('✔',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),):Text('X',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),),
                    height: 80,width: 40,decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      color: widget.bed == 'Yes'?Colors.green:Colors.red
                  ),),
                ),)),

            Card(
                color: Colors.teal,
                elevation: 2,
                child: ListTile(title: const Text('Wifi',style: TextStyle(color: Colors.white),),trailing: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(child: widget.wifi == 'Yes'?Text('✔',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),):Text('X',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),),
                    height: 80,width: 40,decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      color: widget.wifi == 'Yes'?Colors.green:Colors.red
                  ),),
                ),)),

          ],
        ),
      ),),);

  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: _boxDecoration(),
        child: SafeArea(
          child: Column(
            children: [
              _topBar(widget.name),
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
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
