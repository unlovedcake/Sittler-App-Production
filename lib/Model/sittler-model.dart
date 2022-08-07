class SittlerModel {
  String? uid;
  String? fullName;
  String? email;
  String? address;
  String? contactNumber;
  String? gender;
  bool? active;
  String? token;
  Map? rating;
  String? imageUrl = "";
  Map? position;
  double? distance;

  SittlerModel(
      {this.uid,
      this.fullName,
      this.email,
      this.address,
      this.contactNumber,
      this.gender,
      this.active,
      this.token,
      this.rating,
      this.imageUrl,
      this.position,
      this.distance});

  // receiving data from server
  factory SittlerModel.fromMap(map) {
    return SittlerModel(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      address: map['address'],
      contactNumber: map['contactNumber'],
      gender: map['gender'],
      active: map['active'],
      token: map['token'],
      rating: map['rating'],
      imageUrl: map['imageUrl'],
      position: map['position'],
      distance: map['distance'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'address': address,
      'contactNumber': contactNumber,
      'gender': gender,
      'active': active,
      'token': token,
      'rating': rating,
      'imageUrl': imageUrl,
      'position': position,
      'distance': distance,
    };
  }
}
