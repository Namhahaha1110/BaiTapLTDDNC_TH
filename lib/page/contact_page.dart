import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Header banner ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0EA5E9), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Thông tin liên hệ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Lập trình di động nâng cao',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Sinh viên ──────────────────────────────────────
            _infoCard(
              icon: Icons.person,
              color: Colors.blue,
              title: 'Sinh viên',
              items: [
                _infoRow(Icons.badge, 'MSSV', '23DH114467'),
                _infoRow(Icons.person_outline, 'Họ tên', 'Lê Hoàng Nam'),
                _infoRow(
                  Icons.class_,
                  'Lớp',
                  'Lập trình di động nâng cao - Thực hành',
                ),
                _infoRow(Icons.account_balance, 'Trường', 'HUFLIT'),
              ],
            ),

            const SizedBox(height: 14),

            // ── Liên hệ ────────────────────────────────────────
            _infoCard(
              icon: Icons.contact_mail,
              color: Colors.indigo,
              title: 'Liên hệ',
              items: [
                _infoRow(Icons.email, 'Email', '23dh114467@st.huflit.edu.vn'),
                _infoRow(Icons.location_on, 'Địa chỉ', 'TP. Hồ Chí Minh'),
              ],
            ),

            const SizedBox(height: 14),

            // ── Thông tin ứng dụng ─────────────────────────────
            _infoCard(
              icon: Icons.info_outline,
              color: Colors.green,
              title: 'Thông tin ứng dụng',
              items: [
                _infoRow(Icons.app_settings_alt, 'Tên app', 'BaiTapLTDDNC_TH'),
                _infoRow(
                  Icons.build_circle,
                  'Framework',
                  'Flutter 3.x / Dart 3.x',
                ),
                _infoRow(Icons.storage, 'Dữ liệu', 'Firebase + SQLite'),
                _infoRow(Icons.calendar_today, 'Học kỳ', 'HK2 – 2025-2026'),
              ],
            ),

            const SizedBox(height: 14),

            // ── Tech stack ─────────────────────────────────────
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.layers,
                            color: Colors.purple,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Công nghệ sử dụng',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TechChip(label: 'Flutter', color: Colors.blue),
                        _TechChip(label: 'Dart', color: Colors.teal),
                        _TechChip(label: 'Firebase', color: Colors.orange),
                        _TechChip(label: 'SQLite', color: Colors.green),
                        _TechChip(label: 'Provider', color: Colors.indigo),
                        _TechChip(label: 'GetX', color: Colors.pink),
                        _TechChip(label: 'Riverpod', color: Colors.cyan),
                        _TechChip(label: 'Bloc', color: Colors.deepPurple),
                        _TechChip(label: 'MobX', color: Colors.red),
                        _TechChip(label: 'Redux', color: Colors.brown),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Footer ─────────────────────────────────────────
            Text(
              '© 2025–2026 · HUFLIT',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color color,
    required String title,
    required List<Widget> items,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.black54, fontSize: 13),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  final String label;
  final Color color;

  const _TechChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
