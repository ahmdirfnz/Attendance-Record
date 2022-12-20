class Attendee {
  String? user;
  String? phone;
  String? checkIn;

  Attendee({ required this.user, required this.phone, required this.checkIn }); // Make parameter for Attendee model

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(user: json['user'], phone: json['phone'], checkIn: json['check-in']); // Map parameter from json to model

}