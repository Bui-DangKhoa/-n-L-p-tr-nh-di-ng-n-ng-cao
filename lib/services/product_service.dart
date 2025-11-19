import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference<ProductModel> get _productsRef => _firestore
      .collection('products')
      .withConverter<ProductModel>(
        fromFirestore: (snapshot, _) => ProductModel.fromMap(snapshot.data()!),
        toFirestore: (product, _) => product.toMap(),
      );

  /// Lấy danh sách sản phẩm (tùy chọn theo category)
  Stream<List<ProductModel>> getProducts({String? category}) {
    Query<ProductModel> query = _productsRef.where('isActive', isEqualTo: true);

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) {
        final product = doc.data();
        product.id = doc.id; // gán id Firestore
        return product;
      }).toList(),
    );
  }

  /// Upload nhiều ảnh lên Firebase Storage
  Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    for (File image in images) {
      try {
        final ref = _storage.ref().child(
          'products/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}',
        );
        await ref.putFile(image);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      } catch (e) {
        print("❌ Lỗi upload ảnh: $e");
      }
    }
    return imageUrls;
  }

  /// Thêm sản phẩm mới
  Future<void> addProduct(ProductModel product) async {
    try {
      if (product.id.isEmpty) {
        final docRef = await _productsRef.add(product);
        product.id = docRef.id;
        await docRef.set(product); // cập nhật id vào Firestore
      } else {
        await _productsRef.doc(product.id).set(product);
      }
    } catch (e) {
      print("❌ Lỗi thêm sản phẩm: $e");
    }
  }

  /// Cập nhật sản phẩm
  Future<void> updateProduct(ProductModel product) async {
    try {
      await _productsRef.doc(product.id).update(product.toMap());
    } catch (e) {
      print("❌ Lỗi cập nhật sản phẩm: $e");
    }
  }

  /// Xóa sản phẩm (soft delete)
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsRef.doc(productId).update({'isActive': false});
    } catch (e) {
      print("❌ Lỗi xóa sản phẩm: $e");
    }
  }

  /// Lấy thông tin 1 sản phẩm
  Future<ProductModel?> getProduct(String productId) async {
    try {
      final doc = await _productsRef.doc(productId).get();
      final product = doc.data();
      if (product != null) {
        product.id = doc.id;
      }
      return product;
    } catch (e) {
      print("❌ Lỗi lấy sản phẩm: $e");
      return null;
    }
  }

  // === ADMIN MANAGEMENT METHODS ===

  /// Get all products as Map for admin management
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      print('📦 Loading all products from Firestore...');
      final querySnapshot = await _firestore
          .collection('products')
          .orderBy('name')
          .get();

      final products = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      print('✅ Loaded ${products.length} products');
      return products;
    } catch (e) {
      print('❌ Error loading products: $e');
      rethrow;
    }
  }

  /// Add new product from Map data
  Future<String> addProductFromMap(Map<String, dynamic> productData) async {
    try {
      print('📦 Adding new product: ${productData['name']}');

      // Add timestamp and default values
      productData['createdAt'] = FieldValue.serverTimestamp();
      productData['updatedAt'] = FieldValue.serverTimestamp();
      productData['isActive'] = true;

      final docRef = await _firestore.collection('products').add(productData);

      print('✅ Product added with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error adding product: $e');
      rethrow;
    }
  }

  /// Update existing product from Map data
  Future<void> updateProductFromMap(
    String productId,
    Map<String, dynamic> productData,
  ) async {
    try {
      print('📦 Updating product: $productId');

      // Add timestamp
      productData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('products')
          .doc(productId)
          .update(productData);

      print('✅ Product updated successfully');
    } catch (e) {
      print('❌ Error updating product: $e');
      rethrow;
    }
  }

  /// Delete product (hard delete for admin)
  Future<void> deleteProductHard(String productId) async {
    try {
      print('📦 Deleting product: $productId');

      await _firestore.collection('products').doc(productId).delete();

      print('✅ Product deleted successfully');
    } catch (e) {
      print('❌ Error deleting product: $e');
      rethrow;
    }
  }
}
