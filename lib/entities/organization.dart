import 'package:final_proj/entities/donation.dart';
import 'package:final_proj/entities/user.dart';

class Organization {
  final String id;
  String name;
  String description;
  bool openForDonations;
  final List<User> users;

  Organization({
    this.id = '1312',
    this.name = "(Organization)",
    this.description = "",
    this.openForDonations = false,
    this.users = const [],
  });
}
