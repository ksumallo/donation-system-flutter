import 'package:final_proj/entities/donations.dart';
import 'package:final_proj/entities/organization.dart';

class User {
  final String uid;
  final String name;
  final String username;
  final List<String> addresses;
  final String contactNumber;
  final List<Donation> donations;
  final List<Organization> organizations;

  User({
    required this.uid,
    required this.name,
    required this.username,
    required this.addresses,
    required this.contactNumber,
    this.donations = const [],
    this.organizations = const [],
  });
}