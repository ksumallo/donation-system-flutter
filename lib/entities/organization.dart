import 'package:final_proj/entities/donation.dart';
import 'package:final_proj/entities/user.dart';

class Organization {
  final String id;
  String name;
  String description;
  bool openForDonations;
  final List<User> users;

  Organization({
    required this.id,
    required this.name,
    this.description = "",
    this.openForDonations = false,
    this.users = const [],
  });
}
