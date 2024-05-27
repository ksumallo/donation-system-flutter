// TODO: Properly implement this class

import 'dart:developer';

import 'package:final_proj/entities/user.dart';
import 'package:final_proj/entities/organization.dart';
import 'package:image_picker/image_picker.dart';

enum DonationStatus {
  pending,
  confirmed,
  scheduledForPickup,
  complete,
  canceled,
}

class Donation {
  static const List<String> weightUnits = ['kg', 'lb'];

  final User donor;
  final Organization receipient;

  final List<String> itemCategories;
  final bool isPickup;
  final double weight;
  final String weightUnit;

  final String date = '';
  String time = '';

  final XFile image;
  final List<String> addresses;
  final String contact;

  final DonationStatus status;

  Donation({
    required this.donor,
    required this.receipient,
    required this.itemCategories,
    required this.isPickup,
    required this.weight,
    required this.weightUnit,
    required this.image,
    required this.addresses,
    required this.contact,
    required this.status,
  });

  debug() {
    log('itemCategories: $itemCategories');
    log('isPickup: $isPickup');
    log('weight: $weight');
    log('weightUnit: $weightUnit');
    log('date: $date');
    log('time: $time');
    log('image: $image');
    log('addresses: $addresses');
    log('contact: $contact');
    log('status: $status');
  }
}
