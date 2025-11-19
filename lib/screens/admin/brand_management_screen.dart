import 'package:flutter/material.dart';
import '../../models/brand_model.dart';
import '../../services/brand_service.dart';

class BrandManagementScreen extends StatefulWidget {
  const BrandManagementScreen({super.key});

  @override
  State<BrandManagementScreen> createState() => _BrandManagementScreenState();
}

class _BrandManagementScreenState extends State<BrandManagementScreen> {
  final BrandService _brandService = BrandService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý thương hiệu'),
      ),
      body: StreamBuilder<List<BrandModel>>(
        stream: _brandService.getBrandsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final brands = snapshot.data ?? [];
          if (brands.isEmpty) {
            return const Center(child: Text('Chưa có thương hiệu nào'));
          }

          return ListView.builder(
            itemCount: brands.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        brand.logoUrl.isNotEmpty ? NetworkImage(brand.logoUrl) : null,
                    child: brand.logoUrl.isEmpty
                        ? Text(
                            brand.name.isNotEmpty
                                ? brand.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )
                        : null,
                  ),
                  title: Text(
                    brand.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    brand.description.isEmpty
                        ? 'Chưa có mô tả'
                        : brand.description,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _openBrandForm(brand: brand);
                      } else if (value == 'toggle') {
                        _brandService.toggleBrandStatus(brand.id, !brand.isActive);
                      } else if (value == 'delete') {
                        _confirmDelete(brand);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Sửa'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'toggle',
                        child: Row(
                          children: [
                            Icon(
                              brand.isActive
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(brand.isActive ? 'Tắt' : 'Bật'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Xóa'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openBrandForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(BrandModel brand) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa thương hiệu'),
        content: Text('Bạn có chắc chắn muốn xóa ${brand.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _brandService.deleteBrand(brand.id);
    }
  }

  Future<void> _openBrandForm({BrandModel? brand}) async {
    final nameController = TextEditingController(text: brand?.name ?? '');
    final descriptionController =
        TextEditingController(text: brand?.description ?? '');
    final logoUrlController = TextEditingController(text: brand?.logoUrl ?? '');
    var isActive = brand?.isActive ?? true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      brand == null
                          ? 'Thêm thương hiệu'
                          : 'Cập nhật thương hiệu',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Tên thương hiệu',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: logoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Logo URL',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Kích hoạt'),
                      value: isActive,
                      onChanged: (value) => setState(() {
                        isActive = value;
                      }),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vui lòng nhập tên thương hiệu'),
                              ),
                            );
                            return;
                          }

                          final model = BrandModel(
                            id: brand?.id ??
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            name: nameController.text.trim(),
                            description: descriptionController.text.trim(),
                            logoUrl: logoUrlController.text.trim(),
                            isActive: isActive,
                            createdAt: brand?.createdAt,
                          );

                          await _brandService.upsertBrand(model);
                          if (mounted) Navigator.pop(context);
                        },
                        child: Text(brand == null ? 'Tạo mới' : 'Cập nhật'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

