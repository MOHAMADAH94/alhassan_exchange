class Branch {
  final int id;
  final String name;
  final String city;
  final String address;


  Branch({
    required this.id,
    required this.name,
    required this.city,
    required this.address,

  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      address: json['address'],

    );
  }
}