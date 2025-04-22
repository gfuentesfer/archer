import 'package:intl/intl.dart';

class UserRegistrationModel {
  final int licenseId;
  final String name;
  final String familyName;
  final String email;
  final String birthDate; // yyyy-MM-dd
  final String dni;
  final bool hasClub;
  final int club;
  final String licenseDate;
  final Address address;
  final String category;
  final String modality;
  final String userRoles;
  final bool isActive;
  final String inactiveAt;
  final String createdAt;
  final String updatedAt;
  final bool isBlocked;
  final String blockedAt;

  UserRegistrationModel({
    required this.licenseId,
    required this.name,
    required this.familyName,
    required this.email,
    required this.birthDate,
    required this.dni,
    required this.hasClub,
    required this.club,
    required this.licenseDate,
    required this.address,
    required this.category,
    required this.modality,
    required this.userRoles,
    required this.isActive,
    required this.inactiveAt,
    required this.createdAt,
    required this.updatedAt,
    required this.isBlocked,
    required this.blockedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'licenseId': licenseId,
      'name': name,
      'familyName': familyName,
      'email': email,
      'birthDate': birthDate,
      'dni': dni,
      'hasClub': hasClub,
      'club': club,
      'licenseDate': licenseDate,
      'address': address.toJson(),
      'category': category,
      'modality': modality,
      'userRoles': userRoles,
      'isActive': isActive,
      'inactiveAt': inactiveAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isBlocked': isBlocked,
      'blockedAt': blockedAt,
    };
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final String phone;
  final String mobilePhone;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.phone,
    required this.mobilePhone,
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'phone': phone,
      'mobilePhone': mobilePhone,
    };
  }
}
