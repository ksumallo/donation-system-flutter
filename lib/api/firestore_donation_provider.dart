import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/entities/donation.dart';
import 'package:final_proj/entities/organization.dart';
import 'package:final_proj/entities/user.dart';
import 'package:final_proj/providers/cloud_storage_provider.dart';
import 'package:final_proj/providers/donation_provider.dart';
import 'package:final_proj/providers/organizations.dart';
import 'package:final_proj/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';

class _DonationDao {
  final String donorId;
  final String recipientId;

  final List<String> itemCategories;
  final bool isPickup;
  final double weight;
  final String weightUnit;

  final String pickupDate;
  final String pickupTime;

  final String imagePathCloud;
  final List<String> addresses;
  final String contact;
  final int donationStatus;

  factory _DonationDao.fromDonation(Donation donation, String imagePathCloud) {
    return _DonationDao(
      donorId: donation.donor.uid,
      recipientId: donation.receipient.id,
      itemCategories: donation.itemCategories,
      isPickup: donation.isPickup,
      weight: donation.weight,
      weightUnit: donation.weightUnit,
      pickupDate: donation.date,
      pickupTime: donation.time,
      imagePathCloud: imagePathCloud,
      addresses: donation.addresses,
      contact: donation.contact,
      donationStatus: donation.status.index,
    );
  }

  Future<Donation> toDonation(String id,
      UserProvider userProvider,
      OrganizationProvider organizationProvider,
      CloudStorageProvider cloudStorageProvider,) async {
    final donor = await userProvider.getUserById(donorId);
    final recipient = await organizationProvider.getById(recipientId);
    final imageFile = await cloudStorageProvider.pickFile(imagePathCloud);

    return Donation(
      id: id,
      donor: donor,
      receipient: recipient,
      itemCategories: itemCategories,
      isPickup: isPickup,
      weight: weight,
      weightUnit: weightUnit,
      date: pickupDate,
      time: pickupTime,
      image: XFile(imageFile.path),
      addresses: addresses,
      contact: contact,
      status: DonationStatus.values[donationStatus],
    );
  }

  factory _DonationDao.fromMap(Map<String, dynamic> map) {
    return _DonationDao(
      donorId: map['donor_id'],
      recipientId: map['recipient_id'],
      itemCategories: List<String>.from(map['item_categories']),
      isPickup: map['is_pickup'],
      weight: map['weight'],
      weightUnit: map['weight_unit'],
      pickupDate: map['pickup_date'],
      pickupTime: map['pickup_time'],
      imagePathCloud: map['image_ref'],
      addresses: List<String>.from(map['addresses']),
      contact: map['contact'],
      donationStatus: map['donation_status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'donor_id': donorId,
      'recipient_id': recipientId,
      'item_categories': itemCategories,
      'is_pickup': isPickup,
      'weight': weight,
      'weight_unit': weightUnit,
      'pickup_date': pickupDate,
      'pickup_time': pickupTime,
      'image_ref': imagePathCloud,
      'addresses': addresses,
      'contact': contact,
      'donation_status': donationStatus,
    };
  }

  _DonationDao({
    required this.donorId,
    required this.recipientId,
    required this.itemCategories,
    required this.isPickup,
    required this.weight,
    required this.weightUnit,
    required this.pickupDate,
    required this.pickupTime,
    required this.imagePathCloud,
    required this.addresses,
    required this.contact,
    required this.donationStatus,
  });
}

class FirestoreDonationProvider extends DonationProvider {
  final FirebaseFirestore _firestore;
  final CloudStorageProvider _cloudStorage;
  final UserProvider _userProvider;
  final OrganizationProvider _organizationProvider;

  FirestoreDonationProvider({
    required FirebaseFirestore firestore,
    required CloudStorageProvider cloudStorage,
    required UserProvider userProvider,
    required OrganizationProvider organizationProvider,
  })
      : _firestore = firestore,
        _cloudStorage = cloudStorage,
        _userProvider = userProvider,
        _organizationProvider = organizationProvider;

  @override
  Future<void> addINTERNAL(Donation donation) async {
    String imagePathCloud =
    await _cloudStorage.uploadFile(File(donation.image.path));
    final dao = _DonationDao.fromDonation(donation, imagePathCloud);

    final docRef = _firestore.collection('donations').doc();
    docRef.set(dao.toMap());
  }

  @override
  Future<void> updateINTERNAL(Donation donation) async {
    if (donation.id == null) {
      throw ArgumentError("Donation must have an ID to be updated.");
    }

    final docRef = _firestore.collection('donations').doc(donation.id);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      throw Exception("Donation does not exist.");
    }

    final docMap = docSnapshot.data()!;
    final dao = _DonationDao.fromDonation(
        donation, docMap['image_ref'] as String);

    await docRef.update(dao.toMap());
  }

  @override
  Future<List<Donation>> getByDonorINTERNAL(User donor) async {
    final docRef = _firestore
        .collection('donations')
        .where('donor_id', isEqualTo: donor.uid);
    final querySnapshot = await docRef.get();
    final docs = querySnapshot.docs;
    final daos = docs
        .map((doc) => _DonationDao.fromMap(doc.data()))
        .toList();

    final ret = <Donation>[];

    for (int i = 0; i < docs.length; i++) {
      _DonationDao dao = daos[i];
      File imageFile = await _cloudStorage.pickFile(dao.imagePathCloud);
      final recipient = await _organizationProvider.getById(dao.recipientId);

      Donation donation = Donation(
        id: docs[i].id,
        donor: donor,
        receipient: recipient,
        itemCategories: dao.itemCategories,
        isPickup: dao.isPickup,
        weight: dao.weight,
        weightUnit: dao.weightUnit,
        date: dao.pickupDate,
        time: dao.pickupTime,
        image: XFile(imageFile.path),
        addresses: dao.addresses,
        contact: dao.contact,
        status: DonationStatus.values[dao.donationStatus],
      );

      ret.add(donation);
    }

    return ret;
  }

  @override
  Future<List<Donation>> getByRecipientINTERNAL(Organization recipient) async {
    final docRef = _firestore
        .collection('donations')
        .where('recipient_id', isEqualTo: recipient.id);
    final querySnapshot = await docRef.get();
    final docs = querySnapshot.docs;
    final daos = docs
        .map((doc) => _DonationDao.fromMap(doc.data()))
        .toList();

    final ret = <Donation>[];

    for (int i = 0; i < docs.length; i++) {
      _DonationDao dao = daos[i];
      File imageFile = await _cloudStorage.pickFile(dao.imagePathCloud);
      final donor = await _userProvider.getUserById(dao.recipientId);

      Donation donation = Donation(
        id: docs[i].id,
        donor: donor,
        receipient: recipient,
        itemCategories: dao.itemCategories,
        isPickup: dao.isPickup,
        weight: dao.weight,
        weightUnit: dao.weightUnit,
        date: dao.pickupDate,
        time: dao.pickupTime,
        image: XFile(imageFile.path),
        addresses: dao.addresses,
        contact: dao.contact,
        status: DonationStatus.values[dao.donationStatus],
      );

      ret.add(donation);
    }

    return ret;
  }

  @override
  Future<Donation> getByIdINTERNAL(String id) async {
    final docSnapshot = await _firestore.collection('donations').doc(id).get();

    if (!docSnapshot.exists) {
      throw Exception("Donation does not exist.");
    }

    final dao = _DonationDao.fromMap(docSnapshot.data()!);
    final imageFile = await _cloudStorage.pickFile(dao.imagePathCloud);
    final donor = await _userProvider.getUserById(dao.donorId);
    final recipient = await _organizationProvider.getById(dao.recipientId);

    return Donation(
      id: id,
      donor: donor,
      receipient: recipient,
      itemCategories: dao.itemCategories,
      isPickup: dao.isPickup,
      weight: dao.weight,
      weightUnit: dao.weightUnit,
      date: dao.pickupDate,
      time: dao.pickupTime,
      image: XFile(imageFile.path),
      addresses: dao.addresses,
      contact: dao.contact,
      status: DonationStatus.values[dao.donationStatus],
    );
  }

  @override
  Future<void> removeINTERNAL(Donation donation) {
    return _firestore
        .collection('donations')
        .doc(donation.id)
        .delete();
  }
}
