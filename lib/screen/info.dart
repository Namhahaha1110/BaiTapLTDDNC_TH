import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final List<String> hobbies;
  final String imageUrl;

  const Info({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    required this.hobbies,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin người dùng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 220,
                  height: 220,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 60),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Center(
              child: Text(
                'Xin chào, $fullName!',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            _row('Email:', email),
            const SizedBox(height: 12),
            _row('Số điện thoại:', phone),
            const SizedBox(height: 12),
            _row('Giới tính:', gender),
            const SizedBox(height: 18),

            const Text(
              'Sở thích:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            ...hobbies.map(
              (h) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(h, style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
            if (hobbies.isEmpty)
              const Text(
                'Không có',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 22))),
      ],
    );
  }
}
