import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/brand_model.dart';

class BrandService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('brands');

  Stream<List<BrandModel>> getBrandsStream() {
    return _collection.orderBy('name').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => BrandModel.fromMap(doc.data())).toList(),
        );
  }

  Future<void> upsertBrand(BrandModel brand) async {
    await _collection.doc(brand.id).set(brand.toMap());
  }

  Future<void> deleteBrand(String id) async {
    await _collection.doc(id).delete();
  }

  Future<void> toggleBrandStatus(String id, bool isActive) async {
    await _collection.doc(id).update({'isActive': isActive});
  }
}

