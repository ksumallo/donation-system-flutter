import 'package:final_proj/entities/donation.dart';
import 'package:final_proj/entities/organization.dart';

class DonationDrive {
  List<Donation> donations;
  Organization proponent;

  DonationDrive({required this.proponent, required this.donations});

  addDonation(Donation donation) {
    donations.add(donation);
  }
}
