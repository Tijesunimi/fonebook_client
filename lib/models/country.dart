class Country {
  final int id;
  final String name;
  final String phoneCode;

  Country(this.id, this.name, this.phoneCode);

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(json['id'], json['name'], json['phone_code']);
  }
}