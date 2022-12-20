class Attendance {
  String? user;
  String? phone;
  String? checkIn;

  Attendance({
    this.user, this.phone, this.checkIn
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    phone = json['phone'];
    checkIn = json['check-in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['phone'] = this.phone;
    data['check-in'] = this.checkIn;
    return data;
  }
}