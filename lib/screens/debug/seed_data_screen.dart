import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeedDataScreen extends StatefulWidget {
  const SeedDataScreen({super.key});

  @override
  State<SeedDataScreen> createState() => _SeedDataScreenState();
}

class _SeedDataScreenState extends State<SeedDataScreen> {
  bool _isLoading = false;
  String _message = '';

  final List<Map<String, dynamic>> _sampleProducts = [
    {
      'name': 'iPhone 15 Pro Max',
      'description':
          'Điện thoại cao cấp với chip A17 Pro, camera 48MP, màn hình 6.7 inch Super Retina XDR',
      'price': 29990000,
      'category': 'Điện thoại',
      'imageUrl':
          'https://images.unsplash.com/photo-1592286927505-38a32e1d3a44?w=500',
    },
    {
      'name': 'MacBook Pro M3',
      'description':
          'Laptop chuyên nghiệp với chip M3, RAM 16GB, SSD 512GB, màn hình Retina 14 inch',
      'price': 45990000,
      'category': 'Laptop',
      'imageUrl':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
    },
    {
      'name': 'iPad Air M2',
      'description':
          'Máy tính bảng mạnh mẽ với chip M2, màn hình Liquid Retina 10.9 inch',
      'price': 18990000,
      'category': 'Máy tính bảng',
      'imageUrl':
          'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500',
    },
    {
      'name': 'AirPods Pro 2',
      'description':
          'Tai nghe không dây với chống ồn chủ động, âm thanh spatial audio',
      'price': 6490000,
      'category': 'Phụ kiện',
      'imageUrl':
          'https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?w=500',
    },
    {
      'name': 'Samsung Galaxy S24 Ultra',
      'description':
          'Flagship Android với bút S Pen, camera 200MP, màn hình Dynamic AMOLED 2X',
      'price': 27990000,
      'category': 'Điện thoại',
      'imageUrl':
          'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=500',
    },
    {
      'name': 'Dell XPS 15',
      'description':
          'Laptop cao cấp với Intel Core i7, RAM 32GB, SSD 1TB, màn hình 4K OLED',
      'price': 52990000,
      'category': 'Laptop',
      'imageUrl':
          'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=500',
    },
    {
      'name': 'Apple Watch Series 9',
      'description':
          'Đồng hồ thông minh với chip S9, Always-On Retina display, theo dõi sức khỏe',
      'price': 10990000,
      'category': 'Phụ kiện',
      'imageUrl':
          'https://images.unsplash.com/photo-1434493789847-2f02dc6ca35d?w=500',
    },
    {
      'name': 'Sony WH-1000XM5',
      'description': 'Tai nghe chống ồn cao cấp, âm thanh Hi-Res, pin 30 giờ',
      'price': 8990000,
      'category': 'Phụ kiện',
      'imageUrl':
          'https://images.unsplash.com/photo-1545127398-14699f92334b?w=500',
    },
  ];

  Future<void> _seedDatabase() async {
    setState(() {
      _isLoading = true;
      _message = 'Đang thêm dữ liệu mẫu vào Firebase...';
    });

    try {
      final firestore = FirebaseFirestore.instance;
      int successCount = 0;

      for (var product in _sampleProducts) {
        // Thêm timestamp
        product['createdAt'] = FieldValue.serverTimestamp();
        product['updatedAt'] = FieldValue.serverTimestamp();
        product['isActive'] = true;

        // Thêm vào Firestore
        await firestore.collection('products').add(product);
        successCount++;

        setState(() {
          _message =
              'Đã thêm $successCount/${_sampleProducts.length} sản phẩm...';
        });
      }

      setState(() {
        _message =
            '✅ Đã thêm thành công ${_sampleProducts.length} sản phẩm vào Firebase!\n\n'
            'Bây giờ bạn có thể:\n'
            '1. Về trang chủ để xem sản phẩm\n'
            '2. Vào Admin Panel để quản lý\n'
            '3. Thêm/Sửa/Xóa sản phẩm tùy ý';
      });
    } catch (e) {
      setState(() {
        _message = '❌ Lỗi: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _clearDatabase() async {
    setState(() {
      _isLoading = true;
      _message = 'Đang xóa tất cả sản phẩm...';
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore.collection('products').get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        _message = '✅ Đã xóa ${querySnapshot.docs.length} sản phẩm!';
      });
    } catch (e) {
      setState(() {
        _message = '❌ Lỗi: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seed Database'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.storage, size: 48, color: Colors.green),
                    const SizedBox(height: 16),
                    const Text(
                      'Thêm dữ liệu mẫu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Thêm ${_sampleProducts.length} sản phẩm mẫu vào Firebase để test app',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _seedDatabase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'THÊM DỮ LIỆU MẪU',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _clearDatabase,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'XÓA TẤT CẢ SẢN PHẨM',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_message.isNotEmpty)
              Expanded(
                child: Card(
                  color: _message.startsWith('✅')
                      ? Colors.green.shade50
                      : _message.startsWith('❌')
                      ? Colors.red.shade50
                      : Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Text(
                        _message,
                        style: TextStyle(
                          fontSize: 14,
                          color: _message.startsWith('✅')
                              ? Colors.green.shade700
                              : _message.startsWith('❌')
                              ? Colors.red.shade700
                              : Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.info, color: Colors.orange, size: 40),
                    const SizedBox(height: 10),
                    const Text(
                      'Sản phẩm mẫu bao gồm:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '• ${_sampleProducts.where((p) => p['category'] == 'Điện thoại').length} Điện thoại\n'
                      '• ${_sampleProducts.where((p) => p['category'] == 'Laptop').length} Laptop\n'
                      '• ${_sampleProducts.where((p) => p['category'] == 'Máy tính bảng').length} Máy tính bảng\n'
                      '• ${_sampleProducts.where((p) => p['category'] == 'Phụ kiện').length} Phụ kiện',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
