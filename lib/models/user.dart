class User {
  String id;
  final String firstName;
  final String lastName;
  final String email;
  final String country;
  final String phone;
  final bool isSocialAuth;
  String token;
  String _password;

  User(this.firstName, this.lastName, this.email, this.country, this.phone, this._password, this.isSocialAuth);

  User.withoutPassword(this.id, this.firstName, this.lastName, this.email, this.country, this.phone, this.isSocialAuth, this.token);

  set password(String password) {
    this._password = password;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User.withoutPassword(json['id'], json['first_name'], json['last_name'], json['email'], json['country'], json['phone'], json['social_auth'], json['token']);
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': this.firstName,
      'last_name': this.lastName,
      'email': this.email,
      'country': this.country,
      'phone': this.phone,
      'password': this._password,
      'social_auth': this.isSocialAuth.toString()
    };
  }
}