class LoginModel {
  int? statusCode;
  String? token;
  String? message;

  LoginModel({this.statusCode, this.message, this.token});
  LoginModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['code'];
    token = json['token'];
    message = json['message'];
  }
}
