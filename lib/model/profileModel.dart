class profileModel {
  String? username;
  String? password;
  String? confirm_password;
  String? firstLast;
  String? profileUrl;
  String? phone;

  profileModel(this.username, this.password, this.confirm_password, this.firstLast, this.profileUrl, this.phone);

  profileModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    confirm_password = json['confirm_password'];
    firstLast = json['firstLast'];
    profileUrl = json['profileUrl'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['confirm_password'] = this.confirm_password;
    data['firstLast'] = this.firstLast;
    data['profileUrl'] = this.profileUrl;
    data['phone'] = this.phone;
    return data;
  }
}