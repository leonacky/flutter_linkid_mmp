class UserInfo {
  String userId = "";
  String name = "";
  String gender = "";
  String email = "";
  String phone = "";
  int age = 0;
  String country = "";
  String city = "";
  String deviceToken = "";

  UserInfo({
    this.userId = "",
    this.name = "",
    this.gender = "",
    this.email = "",
    this.phone = "",
    this.age = 0,
    this.country = "",
    this.city = "",
    this.deviceToken = "",
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      "userId": userId,
      "name": name,
      "gender": gender,
      "email": email,
      "phone": phone,
      "country": country,
      "city": city,
      "firebaseToken": deviceToken,
    };
    if (age > 0) {
      data["age"] = age;
    }
    print("user to map $data");
    return data;
  }
}
