// TODO: Properly implement this class

import 'dart:developer';

import 'package:image_picker/image_picker.dart';

class Donation {
  static const List<String> weightUnits = ['kg', 'lb'];

  List<String> itemCategories;
  bool isPickup;
  double weight;
  String weightUnit; 

  String date = '';
  String time = '';

  XFile? image;
  List<String> addresses;
  String contact;

  int status;

  Donation(
      {this.itemCategories = const [],
      this.isPickup = true,
      this.weight = 0,
      this.weightUnit = 'kg',
      this.image,
      this.addresses = const [],
      this.contact = '',
      this.status = 0});

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
