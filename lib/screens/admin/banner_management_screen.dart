import 'package:flutter/material.dart';
import '../../models/banner_model.dart';
import '../../services/banner_service.dart';

class BannerManagementScreen extends StatefulWidget {
  const BannerManagementScreen({super.key});

  @override
  State<BannerManagementScreen> createState() => _BannerManagementScreenState();
}

class _BannerManagementScreenState extends State<BannerManagementScreen> {
  final BannerService _bannerService = BannerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý banner'),
      ),
      body: StreamBuilder<List<BannerModel>>(
        stream: _bannerService.getBannersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final banners = snapshot.data ?? [];
          if (banners.isEmpty) {
            return const Center(child: Text('Chưa có banner nào'));
          }

          return ListView.builder(
            itemCount: banners.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      banner.imageUrl,
                      width: 70,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 70,
                        height: 50,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image),
                      ),
                    ),
                  ),
                  title: Text(
                    banner.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thứ tự hiển thị: ${banner.displayOrder}'),
                      if (banner.link?.isNotEmpty == true)
                        Text(
                          banner.link!,
                          style: const TextStyle(color: Colors.blue),
                        ),
                      Text(
                        banner.isActive ? 'Đang hiển thị' : 'Đã tắt',
                        style: TextStyle(
                          color: banner.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _openBannerForm(banner: banner);
                      } else if (value == 'toggle') {
                        _bannerService.toggleBannerStatus(
                          banner.id,
                          !banner.isActive,
                        );
                      } else if (value == 'delete') {
                        _confirmDelete(banner);
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
                              banner.isActive
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(banner.isActive ? 'Tắt' : 'Bật'),
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
        onPressed: () => _openBannerForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(BannerModel banner) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa banner'),
        content: Text('Bạn có chắc chắn muốn xóa "${banner.title}"?'),
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
      await _bannerService.deleteBanner(banner.id);
    }
  }

  Future<void> _openBannerForm({BannerModel? banner}) async {
    final titleController = TextEditingController(text: banner?.title ?? '');
    final imageUrlController =
        TextEditingController(text: banner?.imageUrl ?? '');
    final linkController = TextEditingController(text: banner?.link ?? '');
    final orderController = TextEditingController(
      text: banner?.displayOrder.toString() ?? '0',
    );
    var isActive = banner?.isActive ?? true;

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
                      banner == null ? 'Thêm banner' : 'Cập nhật banner',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Ảnh (URL)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        labelText: 'Liên kết (tùy chọn)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: orderController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Thứ tự hiển thị',
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
                          if (titleController.text.trim().isEmpty ||
                              imageUrlController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Vui lòng nhập tiêu đề và ảnh banner'),
                              ),
                            );
                            return;
                          }

                          final model = BannerModel(
                            id: banner?.id ??
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            title: titleController.text.trim(),
                            imageUrl: imageUrlController.text.trim(),
                            link: linkController.text.trim().isEmpty
                                ? null
                                : linkController.text.trim(),
                            displayOrder:
                                int.tryParse(orderController.text) ?? 0,
                            isActive: isActive,
                            createdAt: banner?.createdAt,
                          );

                          await _bannerService.upsertBanner(model);
                          if (mounted) Navigator.pop(context);
                        },
                        child: Text(banner == null ? 'Tạo mới' : 'Cập nhật'),
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

