class UserModel {
  String userid;
  String userName;
  String userEmail;
  int userPhone;
  String? proPicURL;

  UserModel({
    required this.userid,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
     this.proPicURL,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userid: map['userid'],
      userName: map['userName'],
      userEmail: map['userEmail'],
      userPhone: map['userPhone'],
      proPicURL: map['proPicURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
      'proPicURL': proPicURL,
    };
  }
}
