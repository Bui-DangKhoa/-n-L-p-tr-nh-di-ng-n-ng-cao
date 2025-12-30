import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/banner_model.dart';

class BannerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('banners');

  Stream<List<BannerModel>> getBannersStream() {
    return _collection.orderBy('displayOrder').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => BannerModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> upsertBanner(BannerModel banner) async {
    await _collection.doc(banner.id).set(banner.toMap());
  }

  Future<void> deleteBanner(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> toggleBannerStatus(String id, bool isActive) async {
    await _collection.doc(id).update({'isActive': isActive});
  }
}

