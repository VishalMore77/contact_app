class ContactModel {
  final String? id;
  final String name;
  final String phone;
  final String? email;
  final bool isFavorite;

  ContactModel({
    this.id,
    required this.name,
    required this.phone,
    this.email,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory ContactModel.fromJson(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  ContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    bool? isFavorite,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String getInitials() {
    List<String> names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
