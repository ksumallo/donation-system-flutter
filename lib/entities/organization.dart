import 'package:final_proj/entities/donations.dart';

class Organization {
  final List<Donation> donations;
  final String id;
  String name;
  String description;
  bool openForDonations;

  Organization({
    required this.id,
    required this.name,
    this.description = "",
    this.openForDonations = false,
    this.donations = const [],
  });
}