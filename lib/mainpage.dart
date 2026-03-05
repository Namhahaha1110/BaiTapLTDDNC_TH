import 'dart:io';
import 'package:flutter/material.dart';

import 'page/defaultwidget.dart';
import 'page/home_dashboard.dart';
import 'page/register.dart';
import 'page/login.dart';
import 'page/info_tab.dart';
import 'page/product_list_screen.dart';
import 'page/product_grid_screen.dart';
import 'page/product_table_screen.dart';
import 'page/firebase_category_manager_screen.dart';
import 'page/firebase_product_manager_screen.dart';
import 'state/session.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;

  void _safeSetIndex(int i, int max) {
    if (i < 0) i = 0;
    if (i > max) i = 0;
    _selectedIndex = i;
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final user = session.user;

    // ✅ CHỈ HIỆN INFO KHI: có user và KHÔNG phải guest
    final showInfo = user != null && !session.isGuest;

    final headerName = user?.fullname ?? 'Guest';
    final headerEmail = user?.email ?? '—';

    final avatarPath =
        session.avatarPath; // ✅ avatar hiện tại (null nếu chưa có / guest)

    final pages = <Widget>[
      HomeDashboard(),
      const DefaultWidget(title: 'Contact'),
      showInfo ? const InfoTab() : const RegisterPage(),
    ];

    final navItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      const BottomNavigationBarItem(
        icon: Icon(Icons.contact_mail),
        label: 'Contact',
      ),
      BottomNavigationBarItem(
        icon: Icon(showInfo ? Icons.supervised_user_circle : Icons.person_add),
        label: showInfo ? 'Info' : 'Register',
      ),
    ];

    _safeSetIndex(_selectedIndex, pages.length - 1);

    return Scaffold(
      appBar: AppBar(title: const Text('My App Navigator')),

      // ================= DRAWER =================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: (avatarPath != null)
                        ? FileImage(File(avatarPath))
                        : null,
                    child: (avatarPath == null)
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    headerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    headerEmail,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),
            ListTile(
              leading: Icon(
                showInfo ? Icons.supervised_user_circle : Icons.person_add,
              ),
              title: Text(showInfo ? 'Info' : 'Register'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 2);
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Sản phẩm (List)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_on),
              title: const Text('Sản phẩm (Grid)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductGridScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_rows),
              title: const Text('Sản phẩm (Table)'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductTableScreen()),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.cloud, color: Colors.orange),
              title: const Text('Firebase - Danh mục'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FirebaseCategoryManagerScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload, color: Colors.orange),
              title: const Text('Firebase - Sản phẩm'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FirebaseProductManagerScreen(),
                  ),
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                session.logout();
                Navigator.pop(context);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              },
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: pages[_selectedIndex],

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: navItems,
      ),
    );
  }
}
