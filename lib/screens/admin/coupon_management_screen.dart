import 'package:flutter/material.dart';
import '../../models/coupon_model.dart';
import '../../services/coupon_service.dart';

class CouponManagementScreen extends StatefulWidget {
  const CouponManagementScreen({super.key});

  @override
  State<CouponManagementScreen> createState() =>
      _CouponManagementScreenState();
}

class _CouponManagementScreenState extends State<CouponManagementScreen> {
  final CouponService _couponService = CouponService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý mã giảm giá'),
      ),
      body: StreamBuilder<List<CouponModel>>(
        stream: _couponService.getAllCoupons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final coupons = snapshot.data ?? [];
          if (coupons.isEmpty) {
            return const Center(
              child: Text('Chưa có mã giảm giá nào'),
            );
          }

          return ListView.builder(
            itemCount: coupons.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    '${coupon.code} - ${coupon.title}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(coupon.description),
                      Text(
                        coupon.type == 'percentage'
                            ? 'Giảm ${coupon.value}%'
                            : 'Giảm ${coupon.value.toStringAsFixed(0)}đ',
                      ),
                      Text(
                        'Hiệu lực: ${_formatDate(coupon.startDate)} - ${_formatDate(coupon.endDate)}',
                      ),
                      Text(
                        coupon.isActive ? 'Đang hoạt động' : 'Đã tắt',
                        style: TextStyle(
                          color: coupon.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'toggle') {
                        _couponService.toggleCouponStatus(
                          coupon.id,
                          !coupon.isActive,
                        );
                      } else if (value == 'delete') {
                        _confirmDelete(coupon);
                      } else if (value == 'edit') {
                        _openCouponForm(coupon: coupon);
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
                              coupon.isActive
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(coupon.isActive ? 'Tắt' : 'Bật'),
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
        onPressed: () => _openCouponForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _confirmDelete(CouponModel coupon) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa mã giảm giá'),
        content: Text('Bạn có chắc chắn muốn xóa mã ${coupon.code}?'),
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
      await _couponService.deleteCoupon(coupon.id);
    }
  }

  Future<void> _openCouponForm({CouponModel? coupon}) async {
    final codeController = TextEditingController(text: coupon?.code ?? '');
    final titleController = TextEditingController(text: coupon?.title ?? '');
    final descriptionController =
        TextEditingController(text: coupon?.description ?? '');
    final valueController = TextEditingController(
      text: coupon != null ? coupon.value.toString() : '0',
    );
    final minOrderController = TextEditingController(
      text: coupon != null ? coupon.minOrderAmount.toString() : '0',
    );
    final maxDiscountController = TextEditingController(
      text: coupon?.maxDiscountAmount?.toString() ?? '',
    );
    final usageLimitController = TextEditingController(
      text: coupon != null ? coupon.usageLimit.toString() : '0',
    );

    var type = coupon?.type ?? 'percentage';
    var startDate = coupon?.startDate ?? DateTime.now();
    var endDate = coupon?.endDate ?? DateTime.now().add(const Duration(days: 30));
    var isActive = coupon?.isActive ?? true;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon == null
                          ? 'Thêm mã giảm giá'
                          : 'Cập nhật mã giảm giá',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        labelText: 'Mã',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Mô tả',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: const InputDecoration(
                        labelText: 'Loại giảm giá',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'percentage',
                          child: Text('Phần trăm'),
                        ),
                        DropdownMenuItem(
                          value: 'fixed',
                          child: Text('Giảm trực tiếp'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            type = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: valueController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: type == 'percentage'
                            ? 'Giá trị (%)'
                            : 'Giá trị (đồng)',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: minOrderController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Đơn tối thiểu',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: maxDiscountController,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Giảm tối đa (tùy chọn)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: usageLimitController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Giới hạn lượt (0 = không giới hạn)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _DatePickerField(
                            label: 'Ngày bắt đầu',
                            date: startDate,
                            onPicked: (value) => setState(() {
                              startDate = value;
                            }),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DatePickerField(
                            label: 'Ngày kết thúc',
                            date: endDate,
                            onPicked: (value) => setState(() {
                              endDate = value;
                            }),
                          ),
                        ),
                      ],
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
                          if (codeController.text.isEmpty ||
                              titleController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vui lòng nhập mã và tiêu đề'),
                              ),
                            );
                            return;
                          }

                          final couponModel = CouponModel(
                            id: coupon?.id ??
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            code: codeController.text.trim().toUpperCase(),
                            title: titleController.text.trim(),
                            description: descriptionController.text.trim(),
                            type: type,
                            value: double.tryParse(valueController.text) ?? 0,
                            minOrderAmount:
                                double.tryParse(minOrderController.text) ?? 0,
                            maxDiscountAmount:
                                double.tryParse(maxDiscountController.text),
                            usageLimit:
                                int.tryParse(usageLimitController.text) ?? 0,
                            usedCount: coupon?.usedCount ?? 0,
                            startDate: startDate,
                            endDate: endDate,
                            isActive: isActive,
                            createdAt: coupon?.createdAt ?? DateTime.now(),
                          );

                          if (coupon == null) {
                            await _couponService.createCoupon(couponModel);
                          } else {
                            await _couponService.updateCoupon(couponModel);
                          }

                          if (mounted) Navigator.pop(context);
                        },
                        child: Text(coupon == null ? 'Tạo mới' : 'Cập nhật'),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onPicked;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onPicked(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text('${date.day}/${date.month}/${date.year}'),
      ),
    );
  }
}

