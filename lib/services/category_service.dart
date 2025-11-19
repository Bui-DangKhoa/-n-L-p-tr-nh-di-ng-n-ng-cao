import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo category mới
  Future<void> createCategory(CategoryModel category) async {
    try {
      print('📁 CategoryService: Tạo category mới - name: ${category.name}');

      // Tạo ID mới nếu chưa có
      final docRef = category.id.isEmpty
          ? _firestore.collection('categories').doc()
          : _firestore.collection('categories').doc(category.id);

      final newCategory = CategoryModel(
        id: docRef.id,
        name: category.name,
        description: category.description,
        imageUrl: category.imageUrl,
        productCount: 0,
        createdAt: category.createdAt,
      );

      print('📁 CategoryService: Lưu category với ID: ${newCategory.id}');
      await docRef.set(newCategory.toMap());
      print('✅ CategoryService: Tạo category thành công');
    } catch (e) {
      print('❌ CategoryService: Lỗi tạo category - $e');
      throw Exception('Không thể tạo danh mục: $e');
    }
  }

  // Lấy tất cả categories
  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection('categories')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CategoryModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Lấy category theo ID
  Future<CategoryModel?> getCategoryById(String id) async {
    final doc = await _firestore.collection('categories').doc(id).get();
    if (doc.exists) {
      return CategoryModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Cập nhật category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      print('📁 CategoryService: Cập nhật category ID: ${category.id}');
      await _firestore.collection('categories').doc(category.id).update({
        'name': category.name,
        'description': category.description,
        'imageUrl': category.imageUrl,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
      print('✅ CategoryService: Cập nhật category thành công');
    } catch (e) {
      print('❌ CategoryService: Lỗi cập nhật category - $e');
      throw Exception('Không thể cập nhật danh mục: $e');
    }
  }

  // Xóa category
  Future<void> deleteCategory(String id) async {
    try {
      print('📁 CategoryService: Xóa category ID: $id');
      await _firestore.collection('categories').doc(id).delete();
      print('✅ CategoryService: Xóa category thành công');
    } catch (e) {
      print('❌ CategoryService: Lỗi xóa category - $e');
      throw Exception('Không thể xóa danh mục: $e');
    }
  }

  // Cập nhật số lượng sản phẩm trong category
  Future<void> updateProductCount(String categoryId, int count) async {
    await _firestore.collection('categories').doc(categoryId).update({
      'productCount': count,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
