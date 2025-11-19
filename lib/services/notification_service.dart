import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo notification mới
  Future<void> createNotification(NotificationModel notification) async {
    await _firestore
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toMap());
  }

  // Lấy notifications của user
  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Lấy notifications chưa đọc
  Stream<List<NotificationModel>> getUnreadNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Đánh dấu notification đã đọc
  Future<void> markAsRead(String id) async {
    await _firestore.collection('notifications').doc(id).update({
      'isRead': true,
    });
  }

  // Đánh dấu tất cả đã đọc
  Future<void> markAllAsRead(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // Xóa notification
  Future<void> deleteNotification(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }

  // Xóa tất cả notifications của user
  Future<void> deleteAllNotifications(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  // Đếm notifications chưa đọc
  Future<int> getUnreadCount(String userId) async {
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    return snapshot.docs.length;
  }

  // Gửi notification đến tất cả users (Admin feature)
  Future<void> sendBroadcastNotification({
    required String title,
    required String body,
    String type = 'system',
    String? imageUrl,
  }) async {
    final usersSnapshot = await _firestore.collection('users').get();
    final batch = _firestore.batch();

    for (var userDoc in usersSnapshot.docs) {
      final notificationRef = _firestore.collection('notifications').doc();
      final notification = NotificationModel(
        id: notificationRef.id,
        userId: userDoc.id,
        title: title,
        body: body,
        type: type,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );
      batch.set(notificationRef, notification.toMap());
    }

    await batch.commit();
  }
}
