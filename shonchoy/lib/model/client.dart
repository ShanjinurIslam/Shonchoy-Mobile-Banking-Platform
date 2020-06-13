class Client {
  final String id;
  final String name;
  final String primaryGuardian;
  final String motherName;
  final String idType;
  final String idNumber;
  final String dob;
  final String address;
  final String city;
  final String subdistrict;
  final String district;
  final String postOffice;
  final String postalCode;

  Client(
      {this.id,
      this.name,
      this.primaryGuardian,
      this.motherName,
      this.idType,
      this.idNumber,
      this.dob,
      this.address,
      this.city,
      this.district,
      this.postOffice,
      this.postalCode,
      this.subdistrict});

  factory Client.fromJson(Map<String, dynamic> json) {
    try {
      return Client(
          name: json['name'],
          primaryGuardian: json['primaryGuardian'],
          idType: json['IDType'],
          idNumber: json['IDNumber'],
          dob: json['dob'],
          address: json['address'],
          city: json['city'],
          subdistrict: json['subdistrict'],
          district: json['district'],
          postOffice: json['postOffice'],
          postalCode: json['postalCode']);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
