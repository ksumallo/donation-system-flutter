import 'dart:collection';

import 'package:final_proj/entities/donation.dart';
import 'package:final_proj/entities/organization.dart';
import 'package:final_proj/entities/user.dart';
import 'package:flutter/cupertino.dart';

class DonationGroup {
  final UnmodifiableListView<Donation> donations;
  final int pageNumber;
  final int pageCount;

  DonationGroup({
    required this.donations,
    required this.pageNumber,
    required this.pageCount,
  });
}

abstract class DonationProvider with ChangeNotifier {
  Future<void> addINTERNAL(Donation donation);

  Future<void> updateINTERNAL(Donation donation);

  Future<void> removeINTERNAL(Donation donation);

  Future<List<Donation>> getByDonorINTERNAL(User donor);

  Future<List<Donation>> getByRecipientINTERNAL(Organization recipient);

  Future<Donation> getByIdINTERNAL(String id);

  Future<DonationGroup> getByDonor(
    User donor, {
    required int pageNumber,
    required int pageSize,
  }) async {
    if (pageNumber < 0) {
      throw RangeError("Page number cannot be less than 0");
    }
    List<Donation> donations = await getByDonorINTERNAL(donor);
    int pageCount = (donations.length / pageSize).ceil();

    return DonationGroup(
      donations: UnmodifiableListView(donations.skip(pageNumber * pageSize)),
      pageNumber: pageNumber,
      pageCount: pageCount,
    );
  }

  Future<DonationGroup> getByRecipient(
    Organization recipient, {
    required int pageNumber,
    required int pageSize,
  }) {
    if (pageNumber < 0) {
      throw RangeError("Page number cannot be less than 0");
    }
    return getByRecipientINTERNAL(recipient).then(
      (donations) {
        int pageCount = (donations.length / pageSize).ceil();
        return DonationGroup(
          donations: UnmodifiableListView(
            donations.skip(pageNumber * pageSize).take(pageSize),
          ),
          pageNumber: pageNumber,
          pageCount: pageCount,
        );
      },
    );
  }

  Future<Donation> getById(String id) async {
    return await getByIdINTERNAL(id);
  }

  Future<void> add(Donation donation) async {
    await addINTERNAL(donation);
    notifyListeners();
  }

  Future<void> update(Donation donation) async {
    await updateINTERNAL(donation);
    notifyListeners();
  }

  Future<void> remove(Donation donation) async {
    await removeINTERNAL(donation);
    notifyListeners();
  }
}
