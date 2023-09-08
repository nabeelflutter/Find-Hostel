class HostelModal {
  String id;
  String ownerName;
  String ownerPhoneNumber;
  String hostelName;
  String hostelCity;
  String image;
  String hostelType;
  String wifi;
  String mess;
  String water;
  String parking;
  String bed;
  String security;
  String? hostelDiscription;

  HostelModal(
      {required this.parking,
        required this.hostelDiscription,
      required this.security,
      required this.mess,
      required this.wifi,
      required this.hostelType,
      required this.hostelCity,
      required this.bed,
      required this.image,
      required this.hostelName,
      required this.ownerName,
      required this.ownerPhoneNumber,
      required this.water
      ,required this.id
      });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownername':ownerName,
      'ownernumber': ownerPhoneNumber,
      'hostelname': hostelName,
      'hostelcity': hostelCity,
      'image':image,
      'type':hostelType,
      'wifi':wifi,
      'mess':mess,
      'witer':water,
      'parking':parking,
      'bed':bed,
      'security':security,
      'discription':hostelDiscription
    };
  }
}
