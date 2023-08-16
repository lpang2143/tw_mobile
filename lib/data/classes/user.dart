import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class User {
  int userId;
  String? lastLogin;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String dob;
  bool twRegistered;
  bool buyer;
  bool seller;
  String? profilePicUrl;
  double sellerFee;
  double buyerFee;
  String? password;
  String? stripeUser;
  bool venueOwner;
  bool isStaff;
  bool isSuperuser;
  List<dynamic> groups;
  List<dynamic> userPermissions;

  User(
      {required this.userId,
      required this.lastLogin,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.phoneNumber,
      required this.dob,
      required this.twRegistered,
      required this.buyer,
      required this.seller,
      required this.profilePicUrl,
      required this.sellerFee,
      required this.buyerFee,
      required this.password,
      required this.stripeUser,
      required this.venueOwner,
      required this.isStaff,
      required this.isSuperuser,
      required this.groups,
      required this.userPermissions});

  String getEmail() {
    return email;
  }

  String getFirstName() {
    return firstName;
  }

  String getLastName() {
    return lastName;
  }

  String getPhoneNumber() {
    return phoneNumber;
  }

  String getDOB() {
    return dob;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      lastLogin: json['last_login'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      dob: json['dob'],
      twRegistered: json['tw_registered'],
      buyer: json['buyer'],
      seller: json['seller'],
      profilePicUrl: json['profile_pic_url'],
      sellerFee: json['seller_fee'],
      buyerFee: json['buyer_fee'],
      password: null,
      stripeUser: json['stripe_user'],
      venueOwner: json['venue_owner'],
      isStaff: json['is_staff'],
      isSuperuser: json['is_superuser'],
      groups: json['groups'],
      userPermissions: json['user_permissions'],
    );
  }

  static List<User> fromJsonList(List<dynamic> jsonData) {
    return jsonData.map((json) => User.fromJson(json)).toList();
  }
}
